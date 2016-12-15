class Collection < ApplicationRecord
  serialize :photos, Array

  validates :title, presence: true
  validates :description, presence: true
end
