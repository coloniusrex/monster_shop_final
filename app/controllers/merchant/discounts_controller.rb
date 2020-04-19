class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def new
    @discount = Discount.new
  end

  def create
    discount = current_user.merchant.discounts.new(discount_params)
    if discount.save
      flash[:notice] = 'Succesfully Created Bulk Discount'
      redirect_to merchant_discounts_path
    else
      flash[:error] = 'Incomplete Form, Try Again.'
      redirect_to '/merchant/discounts/new'
    end
  end

  def edit
    @discount = current_user.merchant.discounts.find_by(id:params[:id])
  end

  def update
    @discount = current_user.merchant.discounts.find_by(id:params[:id])
    @discount.update(discount_params)
    if @discount.save
      flash[:notice] = 'Succesfully Updated Bulk Discount'
      redirect_to merchant_discounts_path
    else
      flash[:error] = 'Incomplete Form, Try Again.'
      redirect_to edit_merchant_discount_path
    end
  end

  def destroy
    discount = current_user.merchant.discounts.find_by(id:params[:id])
    flash[:notice] = 'Succesfully Removed Discount'
    redirect_to merchant_discounts_path
  end

  private
  def discount_params
    params.require(:discount).permit(:nickname, :price, :quantity)
  end
end