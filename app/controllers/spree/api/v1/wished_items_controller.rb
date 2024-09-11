module Spree
  module Api
    module V1
      class WishedItemsController < Spree::Api::BaseController

        helper Spree::Wishlists::ApiHelpers

        def create
          authorize! :create, Spree::WishedItem
          @wished_item = Spree::WishedItem.new(wished_item_attributes)

          current_wishlist_user = if params[:user_id] && @current_user_roles.include?('admin')
            Spree.user_class.find(params[:user_id])
          else
            # if the API user is not an admin, or didn't ask for another user,
            # return themselves.
            current_api_user
          end

          @wishlist = current_wishlist_user.wishlists.find(@wished_item[:wishlist_id]) || current_wishlist_user.wishlist

          if @wishlist.include? params[:wished_item][:variant_id]
            @wished_item = @wishlist.wished_items.detect {|wp| wp.variant_id == params[:wished_item][:variant_id].to_i }
          else
            @wished_item.wishlist = @wishlist
            @wished_item.save
          end

          @wishlist.reload
          if @wished_item.persisted?
            respond_with(@wishlist, status: 201, default_template: :show)
          else
            invalid_resource!(@wished_item)
          end
        end

        def update
          @wished_item = Spree::WishedItem.find(params[:id])
          authorize! :update, @wished_item
          @wished_item.update(wished_item_attributes)
          @wishlist = @wished_item.wishlist

          if @wished_item.errors.empty?
            respond_with(@wished_item, default_template: :show)
          else
            invalid_resource!(@wished_item)
          end
        end

        def destroy
          @wished_item =Spree::WishedItem.find(params[:id])
          authorize! :destroy, @wished_item
          @wished_item.destroy
          respond_with(@wished_item, status: 204)
        end

        private

        def wished_item_attributes
          params.require(:wished_item).permit(:variant_id, :wishlist_id, :remark)
        end


      end # eoc

    end
  end
end