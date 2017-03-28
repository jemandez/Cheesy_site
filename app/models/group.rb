class Group < ApplicationRecord
  has_many :students, :dependent => :destroy
  belongs_to :generation, optional: true

  validates :title, presence: true
end
