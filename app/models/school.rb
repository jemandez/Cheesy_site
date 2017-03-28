class School < ApplicationRecord
  has_many :generations, :dependent => :destroy
end
