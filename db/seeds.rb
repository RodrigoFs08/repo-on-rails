# configurações comuns
str_contract_address = ENV["STR_CONTRACT_ADDRESS"]
exchange_contract_address = ENV["EXCHANGE_CONTRACT_ADDRESS"]

# Método auxiliar para criar usuários
def create_user(email, password_digest, name, document, saldo_real, data_atualizacao_saldo)
  User.find_or_create_by!(email: email) do |user|
    user.password_digest = password_digest
    user.name = name
    user.document = document
    user.saldo_real = saldo_real
    user.data_atualizacao_saldo = data_atualizacao_saldo
  end
end

# Multiplicador para converter DREX para a menor unidade
wei_multiplier = 10 ** 18

# Criação de usuários
bc = create_user("admin@bc.com.br", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Banco Central do Brasil", "00038166000105", 0, Time.now)
stn = create_user("stn@gov.com.br", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Secretaria do Tesouro Nacional - STN-MF", "00394460040950", 0, Time.now)
ptp_1 = create_user("participante1@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 1", "122315646541654", 625654.58, Time.now)
ptp_2 = create_user("participante2@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 2", "12345678901231", 1525566.66, Time.now)
ptp_3 = create_user("participante3@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 3", "12345678901233", -505000.25, Time.now)
ptp_4 = create_user("participante4@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 4", "12345678901234", -202500.87, Time.now)
ptp_5 = create_user("participante5@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 5", "12345678901235", 856654.25, Time.now)
ptp_6 = create_user("participante6@email.com", "$2a$12$VHf2qIAkuc15IXBtiOCJLOyAjlXfiA5ARCeaCJxx6U3hNJLg22jkO", "Participante 6", "12345678901236", -656656.58, Time.now)

# Configurações de contratos
str_client_bc = Contracts::Str.new(bc.wallet.private_key)
drex_client = Contracts::Drex.new(bc.wallet.private_key)
tpft_client = Contracts::Tpft.new(bc.wallet.private_key)
exchange_client = Contracts::Exchange.new(bc.wallet.private_key)
drex_client_p1 = Contracts::Drex.new(ptp_1.wallet.private_key)
str_client_p1 = Contracts::Str.new(ptp_1.wallet.private_key)
str_client_p2 = Contracts::Str.new(ptp_2.wallet.private_key)
str_client_p5 = Contracts::Str.new(ptp_5.wallet.private_key)

# Configurações iniciais
str_client_bc.adicionar_participante(ptp_1.wallet.address)
str_client_bc.adicionar_participante(ptp_2.wallet.address)
str_client_bc.adicionar_participante(ptp_3.wallet.address)
str_client_bc.adicionar_participante(ptp_4.wallet.address)
str_client_bc.adicionar_participante(ptp_5.wallet.address)
str_client_bc.adicionar_participante(ptp_6.wallet.address)
str_client_bc.adicionar_stn(stn.wallet.address)

drex_client.set_authorized_wallet(str_contract_address)
tpft_client.set_authorized_wallet(stn.wallet.address)
exchange_client.set_authorized_wallet(str_contract_address)

# Distribuição de tokens
str_client_p1 = Contracts::Str.new(ptp_1.wallet.private_key)
str_client_p1.solicitar_drex(690_852 * wei_multiplier)

str_client_p2 = Contracts::Str.new(ptp_2.wallet.private_key)
str_client_p2.solicitar_drex(1_658_070 * wei_multiplier)

str_client_p5 = Contracts::Str.new(ptp_5.wallet.private_key)
str_client_p5.solicitar_drex(900_856 * wei_multiplier)

# Mint de tokens TPFt
tpft_client_stn = Contracts::Tpft.new(stn.wallet.private_key)
tpft_client_stn.mint(ptp_3.wallet.address, 1, 985 * wei_multiplier, "0x0")
tpft_client_stn.mint(ptp_4.wallet.address, 1, 765 * wei_multiplier, "0x0")
tpft_client_stn.mint(ptp_6.wallet.address, 1, 856 * wei_multiplier, "0x0")

puts "Repo On Rails pronto para simulação"
