require "eth"

class RepoTransactionMonitor
  def initialize(contract_address)
    @client = Eth::Client.create(ENV["DEV_BLOCKCHAIN_HOST"]) # URL do Ganache
    @contract_address = contract_address
    contract_abi = ContractService.get_abi("STR")
    contract_name = "STR"
    @contract = Eth::Contract.from_abi(name: contract_name, address: @contract_address, abi: contract_abi)
  end

  def check_new_transactions
    latest_block = @client.eth_block_number["result"].to_i(16)
    puts latest_block
    # Supondo que você armazena o último bloco verificado em algum lugar
    last_checked_block = 0
    (last_checked_block + 1).upto(latest_block) do |block_number|
      block = @client.eth_get_block_by_number(block_number, true)
      process_transactions(block["result"]["transactions"], block["result"])
    end
  end

  private

  def process_transactions(transactions, block)
    # puts transactions
    transactions.each do |tx|
      next unless tx["to"]&.downcase == @contract_address.downcase
      # Processar transação
      process_transaction(tx, block)
    end
  end

  def process_transaction(tx, block)
    begin
      block_timestamp = block["timestamp"].to_i(16)

      tx_input = tx["input"]
      raw_params = tx_input[10..-1]
      event_abi = @contract.abi.find { |a| a["name"] == "criarOperacaoCompromissada" }
      event_inputs = event_abi["inputs"].map { |i| i["type"] }
      decoded_params = Eth::Abi.decode(event_inputs, raw_params)
      puts Time.at(block_timestamp).to_datetime

      ExchangeTransaction.find_or_create_by!(
        drex_amount: decoded_params[0],
        tpft_token_id: decoded_params[1],
        tpft_amount: decoded_params[2],
        from_address: decoded_params[3],
        to_address: decoded_params[4],
        timestamp: Time.at(block_timestamp).to_datetime, # Ou a data e hora apropriada
      )
    rescue => e
      puts "Erro ao processar a transação: #{e.message}"

      # # Decodificar os parâmetros com base nos tipos
      # # A ordem e os tipos devem corresponder à assinatura da função
      # types = ["uint256", "uint256", "uint256", "address", "address", "uint256", "uint256"]
      # puts Eth::Abi.decode(types, tx_input)
    end
  end
end
