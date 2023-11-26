require "eth"

class SimpleStorage
  include Eth
  CONTRACT_ADDRESS = "0x87C3639c86AeC156bFa3bc82b096b59740F2FE65" # Replace this with your deployed contract address
  ABI = '[{ "inputs": [{ "internalType": "string", "name": "_data", "type": "string" }], "name": "set", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "get", "outputs": [{ "internalType": "string", "name": "oi", "type": "string" }], "stateMutability": "view", "type": "function" }]'
  @client = Eth::Client.create "http://127.0.0.1:7545"
  puts @client.inspect
  key_pair = Eth::Key.new priv: "0x99b9006936e60dbf430c1060dc3a76c59d97276fd24b4c44707232328d85f979"

  # Load some account to sign transactions with later

  key = Eth::Key::Encrypter.perform key_pair, "diguinho"

  @signer = Eth::Key::Decrypter.perform key, "diguinho"

  puts @signer.address.to_s

  def self.contract
    @contract ||= Eth::Contract.from_abi(name: "Teste", address: CONTRACT_ADDRESS, abi: ABI)
  end

  def self.set(data)
    @client.transact_and_wait(contract, "set", data: data, sender_key: @signer, gas_limit: 1000000)
  end

  def self.get
    contract = Eth::Contract.from_abi(name: "Teste", address: CONTRACT_ADDRESS, abi: ABI)
    leitura = @client.call(contract, "get")
  end
end
