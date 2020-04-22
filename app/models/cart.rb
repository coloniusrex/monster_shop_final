class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    if bulk_discount(item_id) != nil
      percent = (100 - (bulk_discount(item_id)[:percent]))/ 100.00
      (@contents[item_id.to_s] * Item.find(item_id).price) * percent
    else
      @contents[item_id.to_s] * Item.find(item_id).price
    end
  end

  def bulk_discount(item_id)
    item = Item.find(item_id)
    merchant = Merchant.find(item.merchant_id)
    merchant.discounts.where("quantity <= ?", count_of(item_id)).order(quantity: :desc).first
  end

  def bulk_savings(item_id)
    full_price = @contents[item_id.to_s] * Item.find(item_id).price
    percent = (100 - (bulk_discount(item_id)[:percent]))/ 100.00
    full_price - (full_price * percent)
  end


  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
