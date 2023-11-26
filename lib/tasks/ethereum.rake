# lib/tasks/ethereum.rake

require "eth"

namespace :ethereum do
  desc "Get current Ethereum block number"
  task get_block_number: :environment do
    begin
      client = Eth::Client.create "http://127.0.0.1:7545"
      block_number = client.eth_block_number
      puts block_number["result"].to_i(16)
    rescue => e
      puts "Erro ao conectar com o nó Ethereum: #{e.message}"
    end
  end
end

#0x87C3639c86AeC156bFa3bc82b096b59740F2FE65
