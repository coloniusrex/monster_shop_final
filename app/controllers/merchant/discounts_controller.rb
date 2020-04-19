class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @merchant = current_user.merchant
  end

  def create
    discount = current_user.merchant.discounts.new(discount_params)
    if discount.save
      flash[:notice] = 'Succesfully Created Bulk Discount'
      redirect_to merchant_discounts_path
    else
      flash[:error] = 'Incomplete Form, Try Again.'
      render :new
    end
  end

  private
  def discount_params
    params.require(:discount).permit(:nickname, :price, :quantity)
  end
end
