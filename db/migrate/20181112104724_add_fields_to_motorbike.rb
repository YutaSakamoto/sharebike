class AddFieldsToMotorbike < ActiveRecord::Migration[5.2]
  def change
    add_column :motorbikes, :latitude, :float
    add_column :motorbikes, :longitude, :float
  end
end
