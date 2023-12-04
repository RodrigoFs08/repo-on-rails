class Wallet < ApplicationRecord
  belongs_to :user
  encrypts :private_key
  validates :address, presence: true, uniqueness: true
  validates :private_key, presence: true
  before_update :prevent_update

  private

  def prevent_update
    throw :abort if persisted?
  end
end
