module Spree
  module V2
    module Storefront
      class WishlistSerializer < BaseSerializer
        set_type :wishlist

        attributes :access_hash, :name, :is_private, :is_default

        belongs_to :user
        has_many :wished_items
      end
    end
  end
end
