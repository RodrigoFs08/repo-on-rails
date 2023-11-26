class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :document
      t.string :remember_token
      t.datetime :remember_token_expires_at

      t.timestamps
    end
  end
end
