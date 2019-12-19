class Jewel < ActiveRecord::Base

  belongs_to :user

  validates :name, :colour, :location_found, presence: true
  validates :weight, :value, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end