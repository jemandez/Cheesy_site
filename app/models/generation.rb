require 'bcrypt'

class Generation < ApplicationRecord
  include BCrypt
  has_many :groups
  belongs_to :school, optional: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
