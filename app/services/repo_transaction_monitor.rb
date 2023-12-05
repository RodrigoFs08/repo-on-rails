require "eth"

class RepoTransactionMonitor
  def initialize(contract_address)
    @client = Eth::Client.create(ENV["DEV_BLOCKCHAIN_HOST"])
    @contract_address = contract_address
    contract_abi = ContractService.get_abi("STR")
    contract_name = "STR"
    @contract = Eth::Contract.from_abi(name: contract_name, address: @contract_address, abi: contract_abi)
  end

  def check_new_transactions
    latest_block = @client.eth_block_number["result"].to_i(16)
    last_checked_block = latest_block - 250
    (last_checked_block + 1).upto(latest_block) do |block_number|
      block = @client.eth_get_block_by_number(block_number, true)
      process_transactions(block["result"]["transactions"], block["result"])
    end
  end

  private

  def process_transactions(transactions, block)
    transactions.each do |tx|
      next unless tx["to"]&.downcase == @contract_address.downcase
      # Processar transação
      process_transaction(tx, block)
    end
  end

  def process_transaction(tx, block)
    begin
      block_timestamp = block["timestamp"].to_i(16)
      # Obtendo o recibo da transação
      tx_hash = tx['hash']
      receipt = @client.eth_get_transaction_receipt(tx_hash)

      
      tx_input = tx["input"]
      raw_params = tx_input[10..-1]
      event_abi = @contract.abi.find { |a| a["name"] == "criarOperacaoCompromissada" }
      event_inputs = event_abi["inputs"].map { |i| i["type"] }
      decoded_params = Eth::Abi.decode(event_inputs, raw_params)
      # O campo 'status' do recibo indica o sucesso (0x1) ou falha (0x0) da transação
      if receipt["result"]["status"] == "0x1"
        puts "Transação #{tx_hash} foi bem-sucedida."
        puts "Salvando transação encontrada no bloco #{block['number']}"

        ExchangeTransaction.find_or_create_by!(
          drex_amount: decoded_params[0],
          tpft_token_id: decoded_params[1],
          tpft_amount: decoded_params[2],
          from_address: decoded_params[3],
          to_address: decoded_params[4],
          timestamp: Time.at(block_timestamp).to_datetime,
        )
      else
        puts "Transação #{tx_hash} falhou."
      end
      
    rescue => e
      puts "Não achou transações de compromissadas no bloco #{block["number"]}"
    end
  end
end
