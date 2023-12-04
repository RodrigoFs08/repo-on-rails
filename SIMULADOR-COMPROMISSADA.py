import pandas as pd
from pandas.tseries.offsets import CustomBusinessDay
import sgs
import random
from datetime import datetime, timedelta
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
#SUPERAVITÁRIO
class Bank_S:
    def __init__(self, name):
        self.name = name
        self.real = random.uniform(1000,10000)
        self.drex = random.uniform(1000,10000)
        #self.cash = self.real + self.drex
        self.bond = random.uniform(1000,10000)

    def __str__(self):
        return self.name
    
# #DEFICITÁRIO    
class Bank_D:
    def __init__(self, name):
        self.name = name
        self.real = random.uniform(-5000,-1000)
        self.drex = random.uniform(500,1000)
       # self.cash = self.real + self.drex
        self.bond = random.uniform(5000,10000)
        
    def __str__(self):
        return self.name
    
#NEUTRO    
class Bank_N:
    def __init__(self, name):
        self.name = name
        self.real = random.uniform(-5000,5000)
        self.drex = random.uniform(1000,1500)
        #self.cash = self.real + self.drex
        self.bond = random.uniform(1000,5000)
        
    def __str__(self):
        return self.name

df_zeragem_interna = pd.DataFrame(columns=['Data',"Início-Fim" ,'Banco', 'Saldo R$', 'Saldo DREX'])
df_compromissadas = pd.DataFrame(columns=['Data', 'Quantidade DREX', 'Quantidade BOND', 'Tomador', 'Credor', 'Prazo', 'Taxa Anual'])
df_saldos =pd.DataFrame(columns=['Data', 'Banco', "Saldo Real", "Saldo DREX", "Saldo Bond"])



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

def gerar_prazo_compromissada(date):
        # Geração aleatória de hora e minuto
        hora = 17
        minuto = random.randint(0, 59)

        # Criar uma data e hora
        data_hora = datetime.strptime(date, '%Y-%m-%d').replace(hour=hora, minute=minuto)
        holidays = ['2023-11-02', '2023-11-15']
        # Adicionar um dia e verificar se é feriado
        while True:
            data_hora_mais_um_dia = data_hora + timedelta(days=1)
            data_formatada = data_hora_mais_um_dia.strftime('%Y-%m-%d')

            if data_formatada not in FERIADOS:
                break

            # Se o dia seguinte for feriado, adicione mais um dia
            data_hora += timedelta(days=1)
        # Formatar a data e hora no formato desejado
        timestamp_formatado = data_hora.strftime('%Y-%m-%d - %I%p %Mmin')
        return timestamp_formatado

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
    gerar_prazo_compromissada(date)
    # Realizando as transações
    for deficit_bank in deficit_banks:
        while deficit_bank.real < 0 and surplus_banks:
            surplus_bank = surplus_banks[-1]

            # Calculando o valor da transação
            transaction_value = min(abs(deficit_bank.real), surplus_bank.drex)
            future_value = transaction_value * (1 + (interest_rate * random.uniform(0.95,1)))

            
            #'Data', , 'Quantidade BOND', 'Tomador', 'Credor', 'Prazo', 'Taxa Anual'
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

            
def add_interest_to_bonds(banks, interest_rate):
    for banco in banks:
        banco.bond = banco.bond * (1 + interest_rate)
        
def add_selic_interest_to_bond_value(bond, interest_rate):
    return bond * (1 + interest_rate)
        
def gerador_caixa_intraday(vies:str):
    if vies == "Bank_D":
        return random.uniform(-1000,-100)
    elif vies == "Bank_S":
        return random.uniform(1000,5000)
    else:
        return random.uniform(-150,500)
    
def gerador_caixa_recompra(vies:str):
    if vies == "Bank_D":
        return random.uniform(-150,-100)
    elif vies == "Bank_S":
        return random.uniform(100,500)
    else:
        return random.uniform(-150,500)
    

##### PRIMEIRO DIA #####

##### FIM DO INTRADAY #####
#1. INICIA AS INSTÂNCIAS DOS BANCOS
#Iniciar as instâncias dos bancos e os valores iniciais de caixa

#Superavitário
banco_a = Bank_S("Banco Superavitário A")
banco_s = Bank_S("Banco Superavitário S")

#Deficitário
banco_b = Bank_D("Banco Deficitário B")
banco_d = Bank_D("Banco Deficitário D")

#Neutro
banco_c = Bank_N("Banco Neutro C")
banco_n = Bank_N("Banco Neutro N")

bank_instances = [banco_a, banco_b, banco_s,banco_d,banco_n,banco_c]

data = [vars(banco) for banco in bank_instances]

df = pd.DataFrame(data)
df.rename(columns={
    'name': 'Banco',
    'real':"Saldo Real",
    'drex':"Saldo DREX",
    'bond': "Saldo Bond"
}, inplace=True)
df['Data'] = simulation_days[0] + '- INTRADAY'
df_saldos = pd.concat([df_saldos, df])

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
data = [vars(banco) for banco in bank_instances]

df = pd.DataFrame(data)
df.rename(columns={
    'name': 'Banco',
    'real':"Saldo Real",
    'drex':"Saldo DREX",
    'bond': "Saldo Bond"
}, inplace=True)
df['Data'] = simulation_days[0] + '- OVERNIGHT'
df_saldos = pd.concat([df_saldos, df])  
##### FIM DO OVERNIGHT #####


for day in simulation_days[1:]:
    ##### INÍCIO DA PRÉ ABERTURA #####
    #4. Valorização dos bonds                               
    print(day)
    # Suponha que 'bancos' seja a sua lista de instâncias de classes
    # add_interest_to_bonds(bank_instances, cdi_ts[day]) #TALVEZ MUDAR
    #PRECISO ALTERAR A VALORIZAÇÃO DOS BONDS PARA A VARIAVEL BOND
    bond = add_selic_interest_to_bond_value(bond, selic_ts[day])
    add_interest_to_bonds(bank_instances, cdi_ts[day])
    ##### INÍCIO DO INTRADAY #####
    #5. OPERAÇÕES DE RECOMPRA
    #identificar as operações compromissadas do dia anterior
    y_day = simulation_days[simulation_days.index(day)-1]
    y_day_transactions = df_compromissadas[df_compromissadas['Data'] == y_day]
    
    # Supondo que df_recompra é o DataFrame resultante do agrupamento por 'Tomador'
    df_recompra = y_day_transactions.groupby(['Tomador', 'Credor'])[['Quantidade DREX', 'Quantidade BOND']].sum()

    # print(df_recompra)
    # # Procurar na lista pelo banco com o nome desejado
    # instancia_encontrada = None
    # for instancia in bank_instances:
    #     if instancia.name == 'Banco Deficitário B':
    #         instancia_encontrada = instancia
    #         break

    # if instancia_encontrada:
    #     print(f"Encontrado: {instancia_encontrada.name}")
    # else:
    #     print(f"Banco '{nome_procurado}' não encontrado na lista.")
    #gerar caixa positivo para deficitários
    #gerador_caixa_recompra(banks_instances)
    #operação de recompra
    
    
    #4.5 GERAÇÃO DE CAIXAS CONFORME ALGORITMO  
    for bank in bank_instances:
        bank.real= gerador_caixa_intraday(type(bank).__name__)
    
    ##### FIM DO INTRADAY #####
        data = [vars(banco) for banco in bank_instances]

    df = pd.DataFrame(data)
    df.rename(columns={
        'name': 'Banco',
        'real':"Saldo Real",
        'drex':"Saldo DREX",
        'bond': "Saldo Bond"
    }, inplace=True)
    df['Data'] = day + '- INTRADAY'
    df_saldos = pd.concat([df_saldos, df])
    
    ##### INÍCIO DO OVERNIGHT #####
    #6. IDENTIFICAR OS DEFICITÁRIOS
    bank_cash_end_intraday = sort_banks_cash(bank_instances)

    # Filtra o dicionário para incluir apenas itens cujo primeiro valor é negativo
    bancos_deficitario_filtrados = {nome: valores for nome, valores in bank_cash_end_intraday.items() if valores[0] < 0}

    #6.5 ZERAGEM INTERNA DOS CAIXAS
    zeragem_drex_interno(bank_instances, bancos_deficitario_filtrados, simulation_days[0], df_zeragem_interna)

    #7. OPERAÇÕES DE COMPROMISSADA PARA ZERAGEM
    saldos_real = {banco.name: banco.real for banco in bank_instances}
    saldos_drex = {banco.name: banco.drex for banco in bank_instances}
    saldos_bond = {banco.name: banco.bond for banco in bank_instances}

        #Checar se os superavitários possuem drex para zerar os deficitários
    check_sum_drex = sum([drex for keys, drex in saldos_drex.items() if drex >= 0] + [real for keys, real in saldos_real.items() if real <= 0])
    if check_sum_drex >= 0:
        #FUNÇÃO PARA COMPROMISSADA
        df_compromissadas = pd.concat([df_compromissadas, compensate_banks(bank_instances, day, cdi_ts[day], selic_ts[day], bond)])

    else:
        print('foi aqui')
        #FUNÇÃO PARA CONVERSÃO
        #Converter o valor em real dos S para drex na medida da sua participação no bolo
        convert_real_to_drex([bank for bank in bank_instances if bank.real > 0], check_sum_drex)
        #FUNÇÃO PARA COMPROMISSADA
        df_compromissadas = pd.concat([df_compromissadas, compensate_banks(bank_instances, day, cdi_ts[day], selic_ts[day], bond)])
    data = [vars(banco) for banco in bank_instances]

    df = pd.DataFrame(data)
    df.rename(columns={
        'name': 'Banco',
        'real':"Saldo Real",
        'drex':"Saldo DREX",
        'bond': "Saldo Bond"
    }, inplace=True)
    df['Data'] = day + ' - OVERNIGHT'
    df_saldos = pd.concat([df_saldos, df])
    ##### FIM DO OVERNIGHT #####

#TRANSFORMAR OS DF EM EXCEL
df_compromissadas = df_compromissadas.loc[df_compromissadas['Quantidade DREX'].astype(int) > 0] 
df_compromissadas.to_excel(r'Registro Compromissadas.xlsx', index=False)
df_compromissadas.to_json(orient='records')
df_saldos.to_excel(r'Registro Saldos.xlsx', index=False)
df_zeragem_interna.to_excel(r'Registo Zeragem Interna.xlsx', index=False)