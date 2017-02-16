class ChangeRelations < ActiveRecord::Migration[5.0]
  def change
    add_reference :photos, :collection, index: true
  end
end
