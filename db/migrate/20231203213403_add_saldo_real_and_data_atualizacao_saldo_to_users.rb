class AddSaldoRealAndDataAtualizacaoSaldoToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :saldo_real, :decimal, :default => 0
    add_column :users, :data_atualizacao_saldo, :datetime
  end
end
