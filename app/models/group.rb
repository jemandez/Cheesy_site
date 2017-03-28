class Group < ApplicationRecord
  has_many :students
  belongs_to :generation, optional: true

  validates :title, presence: true
end
