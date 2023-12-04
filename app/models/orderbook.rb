class Orderbook < ApplicationRecord
  enum tipo_lancamento: { compra: 0, venda: 1 }
  enum tipo_moeda: { titulo_publico: 0 }
end
