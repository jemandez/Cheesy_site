class Photo < ApplicationRecord
  belongs_to :group
  validates :url, presence: true
end
