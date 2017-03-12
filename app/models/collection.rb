class Collection < ApplicationRecord
  has_many :photos
  belongs_to :event, optional: true

  validates :title, presence: true
  validates :description, presence: true
end
