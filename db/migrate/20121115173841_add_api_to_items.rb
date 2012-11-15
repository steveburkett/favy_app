class AddApiToItems < ActiveRecord::Migration
  def change
    add_column :items, :api, :text
    add_column :items, :image, :text
  end
end
