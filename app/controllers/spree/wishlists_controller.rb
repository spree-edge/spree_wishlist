class Spree::WishlistsController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  helper 'spree/products'

  before_action :find_wishlist, only: [:destroy, :show, :update, :edit]

  respond_to :html
  respond_to :js, only: :update

  def new
    @wishlist = Spree::Wishlist.new
    respond_with(@wishlist)
  end

  def index
    @wishlists = spree_current_user.wishlists
  end

  def edit
    respond_with(@wishlist)
  end

  def update
    @wishlist.update wishlist_attributes
    respond_with(@wishlist)
  end

  def show
    respond_with(@wishlist)
  end

  def default
    @wishlist = spree_current_user.wishlist
    respond_with(@wishlist) do |format|
      format.html { render :show }
    end
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user
    @wishlist.save

    respond_with do |format|
      format.html { redirect_to wishlist_url(@wishlist) }
    end
  end

  def destroy
    @wishlist.destroy
    respond_with(@wishlist) do |format|
      format.html { redirect_to account_path }
    end
  end

  private

  def wishlist_attributes
    params.require(:wishlist).permit(:name, :is_default, :is_private, :store_id)
  end

  # Isolate this method so it can be overwritten
  def find_wishlist
    @wishlist = Spree::Wishlist.find_by_access_hash!(params[:id])
  end
end
