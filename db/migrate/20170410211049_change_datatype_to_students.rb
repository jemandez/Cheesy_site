class ChangeDatatypeToStudents < ActiveRecord::Migration[5.0]
  def change
    change_column :students, :photo_timestamp, :datetime
  end
end
