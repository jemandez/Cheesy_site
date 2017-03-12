class Student < ApplicationRecord
  belongs_to :group
  validates :url, presence: true
end
