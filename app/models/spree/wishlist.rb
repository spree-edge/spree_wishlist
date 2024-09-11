class Spree::Wishlist < ActiveRecord::Base
  alias_attribute :access_hash, :token
  belongs_to :user, class_name: Spree.user_class.to_s
   has_many :wished_items, class_name: 'Spree::WishedItem', dependent: :destroy
  before_create :set_access_hash

  validates :name, presence: true

  def include?(variant_id)
    wished_items.map(&:variant_id).include? variant_id.to_i
  end

  def to_param
    access_hash
  end

  def self.get_by_param(param)
    Spree::Wishlist.find_by_access_hash(param)
  end

  def can_be_read_by?(user)
    !self.is_private? || user == self.user
  end

  def is_default=(value)
    self[:is_default] = value
    return unless is_default?
    Spree::Wishlist.where(is_default: true, user_id: user_id).where.not(id: id).update_all(is_default: false)
  end

  def is_public?
    !self.is_private?
  end

  def self.json_api_type
    to_s.demodulize.underscore
  end

  def self.json_api_columns
    column_names.reject { |c| c.match(/_id$|id|preferences|(.*)password|(.*)token|(.*)api_key/) }
  end

  private

  def set_access_hash
    random_string = SecureRandom.hex(16)
    self.access_hash = Digest::SHA1.hexdigest("--#{user_id}--#{random_string}--#{Time.now}--")
  end
end
