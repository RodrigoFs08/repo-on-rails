class User < ApplicationRecord
  include Trestle::Auth::ModelMethods
  include Trestle::Auth::ModelMethods::Rememberable

  has_many :wallets

  # Utilizando before_create
  before_create :build_ethereum_wallet

  private

  def build_ethereum_wallet
    key = Eth::Key.new
    self.wallets.build(address: key.address, private_key: key.private_hex)
  end
end
