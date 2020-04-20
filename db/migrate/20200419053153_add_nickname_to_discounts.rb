class AddNicknameToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :nickname, :string
  end
end
