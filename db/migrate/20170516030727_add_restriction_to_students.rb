class AddRestrictionToStudents < ActiveRecord::Migration[5.0]
  def change
    add_index :students, :did, :unique => true
  end
end
