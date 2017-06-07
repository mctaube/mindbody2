class Resident < ApplicationRecord

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  has_many :rsvps, :dependent => :destroy


end
