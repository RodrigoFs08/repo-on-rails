class Wallet < ApplicationRecord
  belongs_to :user

  # Validações (opcional)
  validates :address, presence: true, uniqueness: true
  validates :private_key, presence: true

  # Lembre-se: Em um ambiente de produção real, você deve tratar a chave privada com extrema cautela.
  # Considerar a utilização de encriptação e métodos de armazenamento seguros.
end
