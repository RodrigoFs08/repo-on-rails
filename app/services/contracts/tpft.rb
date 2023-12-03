require "eth"

module Contracts
  class Tpft
    def initialize(private_key)
      @key = Eth::Key.new(priv: private_key)
      @client = Eth::Client.create ENV["DEV_BLOCKCHAIN_HOST"]
      @contract = Eth::Contract.from_abi(name: "TPFtToken", address: ENV["TPFTTOKEN_CONTRACT_ADDRESS"], abi: ContractService.get_abi("TPFtToken"))
    end

    def set_authorized_wallet(wallet_address)
      call_contract_function("setAuthorizedWallet", wallet_address)
    end

    def mint(account, id, amount, data)
      call_contract_function("mint", account, id, amount, data)
    end

    def burn(account, id, amount)
      call_contract_function("burn", account, id, amount)
    end

    def set_approval_for_all(operator, approved)
      call_contract_function("setApprovalForAll", operator, approved)
    end

    def balance_of(address, id)
      balance = @client.call(@contract, "balanceOf", address, id)
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
