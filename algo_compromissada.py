import pandas as pd
from pandas.tseries.offsets import CustomBusinessDay
import sgs
import random
from datetime import datetime, timedelta
import requests

# Definir o intervalo de datas
start_date = '2023-06-09'
end_date = '2023-11-01'
bond = 1000.0
# Definir os feriados
holidays = ['2023-11-02', '2023-11-15']
FERIADOS = [
    '2023-01-01',
    '2023-02-20',
    '2023-02-21',
    '2023-04-07',
    '2023-04-21',
    '2023-05-01',
    '2023-06-08',
    '2023-09-07',
    '2023-10-12',
    '2023-11-02',
    '2023-11-15',
    '2023-12-25'
]
# Criar uma instância de CustomBusinessDay que leva em conta os feriados
cbd = CustomBusinessDay(holidays=FERIADOS)

# Obter os dias úteis dentro do intervalo
business_days = pd.date_range(start_date, end_date, freq=cbd)

# Exibir os dias úteis
simulation_days = [str(f)[:10] for f in business_days]
l_s = start_date.split("-")
l_e = end_date.split("-")
cdi_ts = sgs.time_serie(12, start='{}/{}/{}'.format(l_s[2], l_s[1], l_s[0]), end='{}/{}/{}'.format(l_e[2], l_e[1], l_e[0]))/100
selic_ts = sgs.time_serie(11, start='{}/{}/{}'.format(l_s[2], l_s[1], l_s[0]), end='{}/{}/{}'.format(l_e[2], l_e[1], l_e[0]))/100

#DEFINIR OS BANCOS
class Participant:
    def __init__(self, name, participant_id, real, drex, bond, bank):
        self.name = name
        self.id = participant_id
        self.real = real
        self.drex = drex
        self.bond = bond
        self.bank = bank

def create_participant_instances(json_list):
    participant_instances = []
    for data in json_list:
        participant = Participant(
            name=data['name'],
            participant_id=data['document'],
            real=data['saldo_real'],
            drex=data['saldo_drex'],
            bond=data['saldo_tpft_1']
        )
        participant_instances.append(participant)
    return participant_instances



def add_selic_interest_to_bond_value(bond, interest_rate):
    return bond * (1 + interest_rate)

# Função para gerar um prazo para compromissada considerando feriados
def gerar_prazo_compromissada(date):
    hora = 17  # Define a hora como 17
    minuto = random.randint(0, 59)  # Gera um minuto aleatório entre 0 e 59

    # Criar uma data e hora baseada na data fornecida e na hora/minuto gerados
    data_hora = datetime.strptime(date, '%Y-%m-%d').replace(hour=hora, minute=minuto)
    
    # Adicionar um dia à data até que não seja um feriado
    while True:
        data_hora_mais_um_dia = data_hora + timedelta(days=1)
        data_formatada = data_hora_mais_um_dia.strftime('%Y-%m-%d')

        if data_formatada not in FERIADOS:  # Verifica se a data não está na lista de feriados
            break

        # Se o dia seguinte for feriado, adiciona mais um dia à data
        data_hora += timedelta(days=1)

    # Formatar a data e hora no formato desejado
    timestamp_formatado = data_hora.strftime('%Y-%m-%d - %I%p %Mmin')
    return timestamp_formatado


# Função para realizar transações entre bancos deficitários e superavitários
def compensate_banks(banks, date, interest_rate, selic_rate, bond):
    # Inicializando as pilhas
    deficit_banks = []
    surplus_banks = []

    # Inicializando o DataFrame para registrar as transações
    transactions = pd.DataFrame(columns=['Data', 'Quantidade DREX', 'Quantidade BOND', 'Tomador', 'Credor', 'Prazo', 'Taxa Anual'])

    # Dividindo os bancos em deficitários e superavitários
    for bank in banks:
        if bank.real < 0:
            deficit_banks.append(bank)
        else:
            surplus_banks.append(bank)

    # Ordenando as pilhas
    deficit_banks.sort(key=lambda bank: bank.real)
    surplus_banks.sort(key=lambda bank: bank.drex, reverse=True)

    # Realizando as transações
    for deficit_bank in deficit_banks:
        while deficit_bank.real < 0 and surplus_banks:
            surplus_bank = surplus_banks[-1]

            # Calculando o valor da transação
            transaction_value = min(abs(deficit_bank.real), surplus_bank.drex)
            future_value = transaction_value * (1 + (interest_rate * random.uniform(0.95,1)))

            # Registrando a transação de DREX
            drex_transaction = pd.DataFrame({
                'Data': [date],
                'Quantidade DREX': [transaction_value],
                'Quantidade BOND': [transaction_value/bond],
                'Tomador': [deficit_bank.name],
                'Credor': [surplus_bank.name],
                'Prazo': [gerar_prazo_compromissada(date)],
                'Taxa Anual': [(1 + selic_rate)**252 - 1] 
            })

            # Registrando a transação de DREX
            transactions = pd.concat([transactions, drex_transaction], ignore_index=True)

            # Atualizando os saldos dos bancos
            deficit_bank.real += transaction_value
            surplus_bank.drex -= transaction_value
            deficit_bank.bond -= transaction_value/bond
            surplus_bank.bond += transaction_value/bond

            # Removendo o banco superavitário da pilha se ele não tem mais DREX
            if surplus_bank.drex == 0:
                surplus_banks.pop()

    return transactions

def post_data_to_route(route, data):
    response = requests.post(route, json=data)

    if response.status_code == 200:
        print("Dados enviados com sucesso!")
    else:
        print(f"Erro ao enviar os dados. Código de status: {response.status_code}")

def get_json_data_from_route(route):
    response = requests.get(route)

    if response.status_code == 200:
        json_data = response.json()
        return json_data
    else:
        print(f"Erro ao obter os dados. Código de status: {response.status_code}")
        return None

#DEFINIR O QUE É COMPROMISSADA

def sort_banks_cash(bancos:list):
    #1. Identificar os negativo e os positivos
    # Ordena as instâncias de bancos com base no atributo 'cash'
    banks_cash_rank = sorted(bancos, key=lambda banco: banco.real)
    # Imprime os nomes dos bancos em ordem crescente de 'cash'dre
    return {banco.name: [banco.real, banco.drex, banco.bond ]for banco in banks_cash_rank}

def convert_real_to_drex(banks, check_sum):
    # Calcular total de real entre os dois bancos
    total = sum([bank.real for bank in banks])
    
    # Calcular a proporção que cada um possui no bolo
    for bank in banks:
        # Calcular a proporção de 'real' que este banco possui
        ratio = bank.real / total

        # Calcular quanto deste banco 'real' deve ser convertido para zerar o check_sum
        real_a_converter = ratio * check_sum

        # Atualizar o valor de 'drex' do banco
        bank.drex += real_a_converter

        # Atualizar o valor de 'real' do banco
        bank.real -= real_a_converter

def zeragem_drex_interno(bank_instances:list, bancos_deficitario_filtrados:dict, date, df_zeragem_interna):
    #2. Iterar participantes deficitários e comparar 
    #se eles tem mais dinheiro tokenizado do que negativo e 
    #realizar essas movimentacoes
    for banco in bank_instances:
        if banco.name in bancos_deficitario_filtrados: 
            df_tmp = pd.DataFrame({'Data': [date], 
                                   "Início-Fim": ['I'] ,
                                   'Banco': [banco.name], 
                                   'Saldo R$':[ banco.real],
                                   'Saldo DREX': [ banco.drex]})
            df_zeragem_interna = pd.concat([df_zeragem_interna,df_tmp])
            if banco.real*-1 > banco.drex:
                #real= -1000 | drex = 500 -> real=-500 drex=0
                banco.real += banco.drex  
                banco.drex = 0
            else:
                #real= -1000 | drex=1500 -> real=0 drex=500
                banco.drex += banco.real  
                banco.real = 0
            df_tmp = pd.DataFrame({'Data': [date], 
                                   "Início-Fim": ['F'] ,
                                   'Banco': [banco.name], 
                                   'Saldo R$':[ banco.real],
                                   'Saldo DREX': [ banco.drex]})
            df_zeragem_interna = pd.concat([df_zeragem_interna,df_tmp])
    return 0

df_zeragem_interna = pd.DataFrame(columns=['Data',"Início-Fim" ,'Banco', 'Saldo R$', 'Saldo DREX'])
df_compromissadas = pd.DataFrame(columns=['Data', 'Quantidade DREX', 'Quantidade BOND', 'Tomador', 'Credor', 'Prazo', 'Taxa Anual'])
df_saldos =pd.DataFrame(columns=['Data', 'Banco', "Saldo Real", "Saldo DREX", "Saldo Bond"])

route_url = 'URL_DA_SUA_ROTA_AQUI'  # Substitua pelo URL correto
json_data_list = get_json_data_from_route(route_url)

if json_data_list:
    bank_instances =create_participant_instances(json_data_list)
    
    ##### INÍCIO DO OVERNIGHT #####
    #2. IDENTIFICAR OS DEFICITÁRIOS
    bank_cash_end_intraday = sort_banks_cash(bank_instances)

    # Filtra o dicionário para incluir apenas itens cujo primeiro valor é negativo
    bancos_deficitario_filtrados = {nome: valores for nome, valores in bank_cash_end_intraday.items() if valores[0] < 0}

    #2.5 ZERAGEM INTERNA DOS CAIXAS
    zeragem_drex_interno(bank_instances, bancos_deficitario_filtrados, simulation_days[0], df_zeragem_interna)

    #3. OPERAÇÕES DE COMPROMISSADA PARA ZERAGEM
    saldos_real = {banco.name: banco.real for banco in bank_instances}
    saldos_drex = {banco.name: banco.drex for banco in bank_instances}
    saldos_bond = {banco.name: banco.bond for banco in bank_instances}

        #Checar se os superavitários possuem drex para zerar os deficitários
    check_sum_drex = sum([drex for keys, drex in saldos_drex.items() if drex >= 0] + [drex for keys, drex in saldos_drex.items() if drex <= 0])
    if check_sum_drex >= 0:
        #FUNÇÃO PARA COMPROMISSADA
        compromissadas = compensate_banks(bank_instances, simulation_days[0], cdi_ts[simulation_days[0]], selic_ts[simulation_days[0]], bond)
        df_compromissadas = pd.concat([df_compromissadas, compromissadas])
        
    else:
        #FUNÇÃO PARA CONVERSÃO
        #Converter o valor em real dos S para drex na medida da sua participação no bolo
        convert_real_to_drex([bank for bank in bank_instances if bank.real > 0])
        #FUNÇÃO PARA COMPROMISSADA
        compromissadas = compensate_banks(bank_instances, simulation_days[0], cdi_ts[simulation_days[0]], selic_ts[simulation_days[0]], bond)
        df_compromissadas = pd.concat([df_compromissadas, compromissadas])

    route_url = 'URL_DA_SUA_ROTA_AQUI'  # Substitua pelo URL correto
    post_data_to_route(route_url, 'data_to_post')