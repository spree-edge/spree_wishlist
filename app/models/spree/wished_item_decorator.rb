module Spree::WishedItemDecorator
  def display_total
    Spree::Money.new(total)
  end

  def total
    quantity * (variant.price || 0)
  end
end
Spree::WishedItem.prepend Spree::WishedItemDecorator
