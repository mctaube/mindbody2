class Rsvp < ApplicationRecord

  validates :session_id, :presence => true
  validates :resident_id, :presence => true, :uniqueness => { :scope => :session_id }

  belongs_to :session
  belongs_to :resident

end
