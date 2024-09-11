class Spree::WishedItemsController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  respond_to :html

  def create
    @wished_item = Spree::WishedItem.new(wished_item_attributes)
    @wishlist = spree_current_user.wishlist

    if @wishlist.include? params[:wished_item][:variant_id]
      @wished_item = @wishlist.wished_items.detect { |wp| wp.variant_id == params[:wished_item][:variant_id].to_i }
    else
      @wished_item.wishlist = spree_current_user.wishlist
      @wished_item.save
    end

    respond_with(@wished_item) do |format|
      format.html { redirect_to wishlist_url(@wishlist) }
    end
  end

  def update
    @wished_item = Spree::WishedItem.find(params[:id])
    @wished_item.update(wished_item_attributes)

    respond_with(@wished_item) do |format|
      format.html { redirect_to wishlist_url(@wished_item.wishlist) }
    end
  end

  def destroy
    @wished_item = Spree::WishedItem.find(params[:id])
    @wished_item.destroy

    respond_with(@wished_item) do |format|
      format.html { redirect_to wishlist_url(@wished_item.wishlist), status: :see_other }
    end
  end

  private

  def wished_item_attributes
    params.require(:wished_item).permit(:variant_id, :remark, :quantity)
  end
end
