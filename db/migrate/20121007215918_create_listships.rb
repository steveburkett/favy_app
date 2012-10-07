class CreateListships < ActiveRecord::Migration
  def change
    create_table :listships do |t|
      t.integer :user_id
      t.integer :followlist_id

      t.timestamps
    end

    add_index :listships, :user_id
    add_index :listships, :followlist_id
    add_index :listships, [:user_id, :followlist_id], unique: true
  end
end
