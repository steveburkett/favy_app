class AddFacebookTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token_expires_at, :integer
    add_column :users, :access_token, :string
  end
end
