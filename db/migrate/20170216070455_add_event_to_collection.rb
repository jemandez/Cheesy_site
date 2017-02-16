class AddEventToCollection < ActiveRecord::Migration[5.0]
  def change
    add_reference :collections, :event, index: true
  end
end
