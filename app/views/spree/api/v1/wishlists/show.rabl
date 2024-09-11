object @wishlist
attributes *wishlist_attributes+[:id]

child :wished_items => :wished_items do
  attributes *wished_item_attributes
end
