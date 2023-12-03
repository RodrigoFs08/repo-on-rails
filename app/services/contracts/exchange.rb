require "eth"

module Contracts
  class Exchange
    def initialize(private_key)
      @key = Eth::Key.new(priv: private_key)
      @client = Eth::Client.create ENV["DEV_BLOCKCHAIN_HOST"]
      @contract = Eth::Contract.from_abi(name: "ExchangeContract", address: ENV["EXCHANGE_CONTRACT_ADDRESS"], abi: ContractService.get_abi("ExchangeContract"))
    end

    def set_authorized_wallet(wallet_address)
      call_contract_function("setAuthorizedWallet", wallet_address)
    end

    def exchange_drex_for_tpft(from, to, drex_amount, tpft_token_id, tpft_amount)
      call_contract_function("exchangeDrexForTpft", from, to, drex_amount, tpft_token_id, tpft_amount)
    end

    private

    def call_contract_function(function_name, *args)
      begin
        tx = @client.transact_and_wait(@contract, function_name, *args, sender_key: @key, gas_limit: 200436)
        puts "Transação #{function_name} enviada: #{tx}"
      rescue StandardError => e
        puts "Ocorreu um erro ao executar a transação #{function_name}: #{e.message}"
      end
    end
  end
end
