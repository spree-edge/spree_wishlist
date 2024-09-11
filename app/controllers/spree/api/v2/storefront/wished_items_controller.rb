module Spree
  module Api
    module V2
      module Storefront
        class WishedItemsController < ::Spree::Api::V2::BaseController

          def create
            spree_authorize! :create, Spree::WishedItem
            spree_authorize! :update, wishlist

            wished_item = Spree::WishedItem.new(wished_item_attributes)

            if wishlist.include? params[:wished_item][:variant_id]
              wished_item = wishlist.wished_items.detect {|wp| wp.variant_id == params[:wished_item][:variant_id].to_i }
            else
              wished_item.wishlist = wishlist
              wished_item.save
            end

            wishlist.reload
            if wished_item.persisted?
              render_serialized_payload { serialize_resource(wished_item) }
            else
              render_error_payload(wished_item.errors.full_messages.to_sentence)
            end
          end

          def update
            spree_authorize! :update, resource
            resource.update(wished_item_attributes)

            if resource.errors.empty?
              render_serialized_payload { serialize_resource(resource) }
            else
              render_error_payload(resource.errors.full_messages.to_sentence)
            end
          end

          def destroy
            spree_authorize! :destroy, resource
            if resource.destroy
              render_serialized_payload { serialize_resource(resource) }
            else
              render_error_payload('Something went wrong')
            end
          end

          private

          def resource
            @resource ||= wishlist.wished_items.find(params[:id])
          end

          def wishlist
            @wishlist ||= Spree::Wishlist.find_by!(access_hash: params[:wishlist_id])
          end

          def wished_item_attributes
            params.require(:wished_item).permit(:variant_id, :quantity, :remark)
          end

          def resource_serializer
            ::Spree::V2::Storefront::WishedItemSerializer
          end
        end
      end
    end
  end
end
