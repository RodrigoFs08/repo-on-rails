require "eth"

module Contracts
  class Drex
    def initialize(private_key)
      @key = Eth::Key.new(priv: private_key)
      @client = Eth::Client.create ENV["DEV_BLOCKCHAIN_HOST"]
      @contract = Eth::Contract.from_abi(name: "DREXToken", address: ENV["DREXTOKEN_CONTRACT_ADDRESS"], abi: ContractService.get_abi("DREXToken"))
    end

    def set_authorized_wallet(wallet_address)
      call_contract_function("setAuthorizedWallet", wallet_address)
    end

    def mint(to_address, amount)
      call_contract_function("mint", to_address, amount)
    end

    def burn(from_address, amount)
      call_contract_function("burn", from_address, amount)
    end

    def approve(spender, amount)
      call_contract_function("approve", spender, amount)
    end

    def balance_of(address)
      balance = @client.call(@contract, "balanceOf", address)
      balance
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
