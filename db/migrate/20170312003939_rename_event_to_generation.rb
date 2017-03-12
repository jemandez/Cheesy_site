class RenameEventToGeneration < ActiveRecord::Migration[5.0]
  def change
    rename_table :events, :generations
  end
end
