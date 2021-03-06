class Address < ActiveRecord::Base
  belongs_to :member
  acts_as_gmappable check_process: false

  def gmaps4rails_address
    "#{self.street}, Col. #{self.colony}, #{self.city}, #{self.state}"
  end

  def full_address
    "Col. #{self.colony}, #{self.city}, #{self.state}"
  end
end
