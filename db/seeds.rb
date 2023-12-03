# configurações comuns
str_contract_address = ENV["STR_CONTRACT_ADRESS"]
exchange_contract_address = ENV["EXCHANGE_CONTRACT_ADDRESS"]

# Método auxiliar para criar usuários
def create_user(email, password_digest, name, document)
  User.find_or_create_by!(email: email) do |user|
    user.password_digest = password_digest
    user.name = name
    user.document = document
  end
end

# Criação de usuários
bc = create_user("admin@bc.com.br", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Banco Central do Brasil", "00038166000105")
ptp_1 = create_user("participante1", "$2a$12$3VK3ETpYX1QzeJmREmjcA.jNYjpXrfTZxEOLUP80f8NyKNIAL.yee", "Vórtx DTVM", "122315646541654")
ptp_2 = create_user("powerranger.rodrigo@gmail.com", "$2a$12$HoMc5CG7el57zEFJg04iIuyXsSuK8ZZ.Ola20oEQVIKiQiQYCIpIa", "Rodrigo Ferreira Santos", "122315646541654")
stn = create_user("stn@gov.com.br", "$2a$12$IsYVsIn.DdPiAdigZEGKx.yHa5R8LYRL4YKX0HyZ9Uytv6OwS.Cl.", "Secretaria do Tesouro Nacional - STN-MF", "00394460040950")

# Configurações de contratos
str_client_bc = Contracts::Str.new(bc.wallet.private_key)
drex_client = Contracts::Drex.new(bc.wallet.private_key)
tpft_client = Contracts::Tpft.new(bc.wallet.private_key)
exchange_client = Contracts::Exchange.new(bc.wallet.private_key)
drex_client_p1 = Contracts::Drex.new(ptp_1.wallet.private_key)

# Configurações iniciais
str_client_bc.adicionar_participante(ptp_1.wallet.address)
str_client_bc.adicionar_participante(ptp_2.wallet.address)
str_client_bc.adicionar_stn(stn.wallet.address)

drex_client.set_authorized_wallet(str_contract_address)
tpft_client.set_authorized_wallet(stn.wallet.address)
exchange_client.set_authorized_wallet(str_contract_address)

# Distribuição de tokens
str_client_p1 = Contracts::Str.new(ptp_1.wallet.private_key)
str_client_p1.solicitar_drex(500)

str_client_p2 = Contracts::Str.new(ptp_2.wallet.private_key)
str_client_p2.solicitar_drex(100)

# Verificação do saldo
puts drex_client.balance_of(ptp_1.wallet.address)
puts drex_client.balance_of(ptp_2.wallet.address)

# Mint de tokens TPFt
tpft_client_stn = Contracts::Tpft.new(stn.wallet.private_key)
tpft_client_stn.mint(ptp_1.wallet.address, 1, 600, "0x0")
tpft_client_stn.mint(ptp_2.wallet.address, 1, 800, "0x0")

# Autorização para operações de câmbio
drex_client_p1.approve(exchange_contract_address, 500)
tpft_client_p2 = Contracts::Tpft.new(ptp_2.wallet.private_key)
tpft_client_p2.set_approval_for_all(exchange_contract_address, true)

# Execução do câmbio
# Trocar DREX por TPFt entre participantes ptp_1 e ptp_2
# Assumindo que ptp_1 está enviando DREX e ptp_2 está recebendo em troca de TPFt
quantidade_drex = 500 # Quantidade de DREX a ser trocada
tpft_token_id = 1 # ID do token TPFt
quantidade_tpft = 800 # Quantidade de TPFt a ser trocada

# Cliente do Exchange para realizar a troca
exchange_client.exchange_drex_for_tpft(ptp_1.wallet.address, ptp_2.wallet.address, quantidade_drex, tpft_token_id, quantidade_tpft)

puts "Troca de #{quantidade_drex} DREX por #{quantidade_tpft} TPFt realizada entre #{ptp_1.name} e #{ptp_2.name}"
