require "eth"

module Contracts
  class Str
    def initialize(private_key)
      @key = Eth::Key.new(priv: private_key)
      @client = Eth::Client.create ENV["DEV_BLOCKCHAIN_HOST"]
      @contract = Eth::Contract.from_abi(name: "STR", address: ENV["STR_CONTRACT_ADDRESS"], abi: ContractService.get_abi("STR"))
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

    def solicitar_drex(amount)
      call_contract_function("solicitarMintDrex", amount)
    end

    def solicitar_burn_drex(amount)
      call_contract_function("solicitarBurnDrex", amount)
    end

    def criar_operacao_compromissada(quantidade_drex, id_tpft, quantidade_tpft, tomador, credor, prazo, taxa_anual)
      tx = call_contract_function("criarOperacaoCompromissada", quantidade_drex, id_tpft, quantidade_tpft, tomador, credor, prazo, taxa_anual)
    end

    private

    def call_contract_function(function_name, *args)
      # Construir a transação
      tx = @client.transact_and_wait(@contract, function_name, *args, sender_key: @key, gas_limit: 1200436)
      # Enviar a transação
      puts "Transação #{function_name} enviada: #{tx}"
      return tx
    end
  end
end
