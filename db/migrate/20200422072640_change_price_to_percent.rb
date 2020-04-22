class ChangePriceToPercent < ActiveRecord::Migration[5.1]
  def change
    rename_column :discounts, :price, :percent
  end
end
