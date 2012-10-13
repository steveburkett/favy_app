class AddSmartTypeToLists < ActiveRecord::Migration
  def change
    add_column :lists, :smart_type, :string
  end
end
