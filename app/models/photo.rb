class Photo < ApplicationRecord
  belongs_to :collection
  validates :url, presence: true
end
