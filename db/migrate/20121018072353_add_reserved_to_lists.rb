class AddReservedToLists < ActiveRecord::Migration
  def change
    add_column :lists, :reserved, :boolean
  end
end
