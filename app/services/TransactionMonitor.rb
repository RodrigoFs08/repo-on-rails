require "eth"
require "ethereum"

class TransactionMonitor
  def initialize(contract_address)
    @client = Eth::Client.create(ENV["DEV_BLOCKCHAIN_HOST"]) # URL do Ganache
    @contract_address = contract_address
    abi = ContractService.get_abi("ExchangeContract")
    @contract_interface = Ethereum::Contract.create(name: "ExchangeContract", abi: abi)
  end

  def check_new_transactions
    latest_block = @client.eth_block_number["result"].to_i(16)
    puts latest_block
    # Supondo que você armazena o último bloco verificado em algum lugar
    last_checked_block = 0
    (last_checked_block + 1).upto(latest_block) do |block_number|
      block = @client.eth_get_block_by_number(block_number, true)
      process_transactions(block["result"]["transactions"]) if block["result"]["transactions"]
    end
  end

  private

  def process_transactions(transactions)
    transactions.each do |tx|
      next unless tx["to"]&.downcase == @contract_address.downcase

      # Processar transação
      process_transaction(tx)
    end
  end

  def process_transaction(tx)

    # Implementar lógica para extrair e armazenar dados da transação
    # puts "Transação para o contrato detectada: #{tx}"
    puts tx["input"]
    decoded_data = @contract_interface.decode_input(tx["input"])
    puts decoded_data
  end
end
