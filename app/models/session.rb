class Session < ApplicationRecord

  validates :session_name, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :instructor_id, :presence => true
  validates :instructor_mb_id, :presence => true
  validates :session_mb_id, :presence => true
  validates :location, :presence => true


  has_many :rsvps
  belongs_to :instructor, :class_name => "User"


end
