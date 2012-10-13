class RemoveSmartTypeFromLists < ActiveRecord::Migration
  def up
    remove_column :lists, :smart_type
      end

  def down
    add_column :lists, :smart_type, :string
  end
end
