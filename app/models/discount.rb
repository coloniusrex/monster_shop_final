class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :quantity, :price, :merchant_id, :nickname
end
