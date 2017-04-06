class AddTimestampToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :photo_timestamp, :date
  end
end
