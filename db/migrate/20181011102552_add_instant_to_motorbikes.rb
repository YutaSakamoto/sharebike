class AddInstantToMotorbikes < ActiveRecord::Migration[5.2]
  def change
    add_column :motorbikes, :instant, :integer, default: 1
  end
end
