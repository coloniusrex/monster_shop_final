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
    item = Item.find(item_id)
    if bulk_discount?(item)
      (@contents[item_id.to_s] * item.price) * bulk_discount_multiplier(item)
    else
      @contents[item_id.to_s] * item.price
    end
  end

  def bulk_discount?(item)
    item.merchant.discounts.where("quantity <= ?", count_of(item.id)).any?
  end

  def bulk_discount(item)
    item.merchant.discounts.where("quantity <= ?", count_of(item.id)).order(quantity: :desc).first

  end

  def bulk_discount_multiplier(item)
    ( ( 100 - bulk_discount(item)[:percent] ) / 100.00 )
  end

  def bulk_savings(item)
    full_price = @contents[item.id.to_s] * item.price
    full_price - (full_price * bulk_discount_multiplier(item))
  end


  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
