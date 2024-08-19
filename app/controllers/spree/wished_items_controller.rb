class Spree::WishedItemsController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  respond_to :html

  def create
    @wished_product = Spree::WishedItem.new(wished_product_attributes)
    @wishlist = spree_current_user.wishlist

    if @wishlist.include? params[:wished_item][:variant_id]
      @wished_product = @wishlist.wished_items.detect { |wp| wp.variant_id == params[:wished_item][:variant_id].to_i }
    else
      @wished_product.wishlist = spree_current_user.wishlist
      @wished_product.save
    end

    respond_to do |format|
      format.html { redirect_to wishlist_url(@wishlist) }
    end
  end

  def update
    @wished_product = Spree::WishedItem.find(params[:id])
    @wished_product.update(wished_product_attributes)

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist) }
    end
  end

  def destroy
    @wished_product = Spree::WishedItem.find(params[:id])
    @wished_product.destroy

    respond_with(@wished_product) do |format|
      format.html { redirect_to wishlist_url(@wished_product.wishlist), status: :see_other }
    end
  end

  private

  def wished_product_attributes
    params.require(:wished_item).permit(:variant_id, :remark, :quantity, :wishlist_id)
  end
end
