require "rake"
require "eth"

namespace :monitor do
  desc "Monitor new transactions for ExchangeContract"
  task :transactions => :environment do
    puts "aqui sim"
    repo_monitor = RepoTransactionMonitor.new(ENV["STR_CONTRACT_ADDRESS"])
    repo_monitor.check_new_transactions
  end
end
