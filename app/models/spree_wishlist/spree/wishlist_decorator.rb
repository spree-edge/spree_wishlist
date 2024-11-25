module SpreeWishlist
  module Spree
    module WishlistDecorator
      def self.prepended(base)
        base.alias_attribute :access_hash, :token
        base.before_create :set_access_hash

        base.validates :name, presence: true
      end

      def can_be_read_by?(user)
        !self.is_private? || user == self.user
      end

      def is_default=(value)
        self[:is_default] = value
        return unless is_default?
        ::Spree::Wishlist.where(is_default: true, user_id: user_id).where.not(id: id).update_all(is_default: false)
      end

      def is_public?
        !self.is_private?
      end

      private

      def set_access_hash
        random_string = SecureRandom.hex(16)
        self.access_hash = Digest::SHA1.hexdigest("--#{user_id}--#{random_string}--#{Time.now}--")
      end
    end
  end
end
Spree::Wishlist.prepend SpreeWishlist::Spree::WishlistDecorator
