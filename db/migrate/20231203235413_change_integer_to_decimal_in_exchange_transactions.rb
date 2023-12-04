class ChangeIntegerToDecimalInExchangeTransactions < ActiveRecord::Migration[7.0]
  def up
    change_column :exchange_transactions, :drex_amount, :decimal, precision: 30, scale: 0
    change_column :exchange_transactions, :tpft_token_id, :decimal, precision: 30, scale: 0
    change_column :exchange_transactions, :tpft_amount, :decimal, precision: 30, scale: 0
  end

  def down
    change_column :exchange_transactions, :drex_amount, :integer
    change_column :exchange_transactions, :tpft_token_id, :integer
    change_column :exchange_transactions, :tpft_amount, :integer
  end
end
