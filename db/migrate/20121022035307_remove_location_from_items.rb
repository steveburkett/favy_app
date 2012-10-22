class RemoveLocationFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :location
      end

  def down
    add_column :items, :location, :string
  end
end
