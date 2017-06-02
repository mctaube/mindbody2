class Resident < ApplicationRecord

has_many :rsvps, :dependent => :destroy


end
