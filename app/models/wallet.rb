class Wallet < ApplicationRecord
  belongs_to :user
  encrypts :private_key
  # Validações (opcional)
  validates :address, presence: true, uniqueness: true
  validates :private_key, presence: true
  # Callback para prevenir atualizações
  before_update :prevent_update

  private

  def prevent_update
    throw :abort if persisted?
  end

  # Lembre-se: Em um ambiente de produção real, você deve tratar a chave privada com extrema cautela.
  # Considerar a utilização de encriptação e métodos de armazenamento seguros.
end
