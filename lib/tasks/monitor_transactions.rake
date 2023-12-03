require "rake"
require "eth"

namespace :monitor do
  desc "Monitor new transactions for ExchangeContract"
  task :transactions => :environment do
    monitor = TransactionMonitor.new(ENV["EXCHANGE_CONTRACT_ADDRESS"])
    monitor.check_new_transactions
  end
end
