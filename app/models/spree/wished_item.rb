class Spree::WishedItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :wishlist

  def total
    quantity * (variant.price || 0)
  end

  def display_total
    Spree::Money.new(total)
  end

  def self.json_api_type
    to_s.demodulize.underscore
  end

  def self.json_api_columns
    column_names.reject { |c| c.match(/_id$|id|preferences|(.*)password|(.*)token|(.*)api_key/) }
  end
end
