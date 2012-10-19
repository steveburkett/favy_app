class AddInitialCommentToItems < ActiveRecord::Migration
  def change
    add_column :items, :initial_comment, :text
  end
end
