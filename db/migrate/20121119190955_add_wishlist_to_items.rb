class AddWishlistToItems < ActiveRecord::Migration
  def change
    add_column :items, :wishlist, :boolean, :default => false
  end
end
