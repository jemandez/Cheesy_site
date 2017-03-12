class Generation < ApplicationRecord
  has_many :groups
  belongs_to :school, optional: true
end
