class CreateExchangeTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_transactions, id: :uuid do |t|
      t.string :from_address
      t.string :to_address
      t.integer :drex_amount
      t.integer :tpft_token_id
      t.integer :tpft_amount
      t.datetime :timestamp

      t.timestamps
    end
  end
end
