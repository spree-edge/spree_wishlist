FactoryBot.define do
  factory :wished_product, class: Spree::WishedItem do
    variant
    wishlist
    remark { 'Some remark..' }
  end
end
