class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :quantity, :price, :merchant_id, :nickname
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :quantity, greater_than: 0
end
