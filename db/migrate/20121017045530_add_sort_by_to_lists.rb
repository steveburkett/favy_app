class AddSortByToLists < ActiveRecord::Migration
  def change
    add_column :lists, :sort_by, :string
  end
end
