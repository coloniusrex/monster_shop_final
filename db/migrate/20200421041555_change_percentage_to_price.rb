class ChangePercentageToPrice < ActiveRecord::Migration[5.1]
  def change
    rename_column :discounts, :percentage, :price
  end
end
