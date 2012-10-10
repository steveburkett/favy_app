class AddPrivacyToLists < ActiveRecord::Migration
  def change
    add_column :lists, :privacy, :integer
  end
end
