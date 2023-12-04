class User < ApplicationRecord
  include Trestle::Auth::ModelMethods
  include Trestle::Auth::ModelMethods::Rememberable

  has_one :wallet

  before_create :build_ethereum_wallet

  def saldo_drex
    drex_client = Contracts::Drex.new(self.wallet.private_key)
    saldo = drex_client.balance_of(self.wallet.address)
    saldo
  end

  def saldo_tpft_1
    tpft_client = Contracts::Tpft.new(self.wallet.private_key)
    saldo = tpft_client.balance_of(self.wallet.address, 1)
    saldo
  end

  private

  def build_ethereum_wallet
    key = Eth::Key.new
    build_wallet(address: key.address, private_key: key.private_hex)
  end
end
