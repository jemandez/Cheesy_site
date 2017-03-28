# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#


if Admin.count == 0
  Admin.new({:email => "m@gmail.com", :password => "123456", :password_confirmation => "123456", :confirmed_at => Time.now }).save
end
