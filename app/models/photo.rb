class Photo < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :description, presence: true, length: { maximum: 400 }
end
