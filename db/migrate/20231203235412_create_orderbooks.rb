class CreateOrderbooks < ActiveRecord::Migration[7.0]
  def change
    create_table :orderbooks, id: :uuid do |t|
      t.string :lancador
      t.integer :tipo_lancamento
      t.integer :tipo_moeda
      t.integer :quantidade
      t.float :taxa
      t.datetime :vencimento
      t.boolean :fechado
      t.string :tomador
      t.string :blockchain_tx

      t.timestamps
    end
  end
end
