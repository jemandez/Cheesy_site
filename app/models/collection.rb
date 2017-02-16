class Collection < ApplicationRecord
  has_many :photos

  validates :title, presence: true
  validates :description, presence: true
end
