class ExchangeTransaction < ApplicationRecord
  validates :from_address, presence: true
  validates :to_address, presence: true
  validates :drex_amount, numericality: { greater_than: 0 }
  validates :tpft_token_id, numericality: { only_integer: true }
  validates :tpft_amount, numericality: { greater_than: 0 }
  validates :timestamp, presence: true
end
