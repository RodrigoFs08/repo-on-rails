require "json"

class ContractService
  TRUFFLE_CONTRACTS_PATH = Rails.root.join("truffle_project", "build", "contracts")

  def self.get_abi(contract_name)
    file_path = File.join(TRUFFLE_CONTRACTS_PATH, "#{contract_name}.json")
    file = File.read(file_path)
    contract_json = JSON.parse(file)
    contract_json["abi"]
  end
end
