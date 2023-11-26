require "eth"
client = Eth::Client.create "HTTP://127.0.0.1:7545"
block_number = client.eth_block_number
puts block_number["result"].to_i(16)
