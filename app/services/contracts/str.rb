require "eth"

module Contracts
  class Str
    def initialize(private_key)
      @key = Eth::Key.new(priv: private_key)
      @client = Eth::Client.create "http://127.0.0.1:8545"
      @contract = Eth::Contract.from_abi(name: "STR", address: ENV["STR_CONTRACT_ADRESS"], abi: ContractService.get_abi("STR"))
    end

    def adicionar_participante(address)
      call_contract_function("adicionarParticipante", address)
    end

    def remover_participante(address)
      call_contract_function("removerParticipante", address)
    end

    def adicionar_stn(address)
      call_contract_function("adicionarSTN", address)
    end

    def remover_stn(address)
      call_contract_function("removerSTN", address)
    end

    private

    def call_contract_function(function_name, address)
      # Construir a transação
      tx = @client.transact_and_wait(@contract, function_name, address, sender_key: @key, gas_limit: 200436)

      # Enviar a transação
      puts "Transação #{function_name} enviada: #{tx}"
    end
  end
end
