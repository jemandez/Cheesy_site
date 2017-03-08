class Event < ApplicationRecord
  has_many :collections
  belongs_to :school
end
