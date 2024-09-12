class RemoveWishedProductsForDeletedVariants < SpreeExtension::Migration[4.2]
  def up
    Spree::WishedItem.includes(:variant).find_each do |wish_item|
      wish_item.destroy unless wish_item.variant
    end
  end

  def down
  end
end
