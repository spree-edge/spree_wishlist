module SpreeWishlist
  module Spree
    module WishedItemDecorator
      def display_total
        ::Spree::Money.new(total)
      end

      def total
        quantity * (variant.price || 0)
      end
    end
  end
end
Spree::WishedItem.prepend SpreeWishlist::Spree::WishedItemDecorator
