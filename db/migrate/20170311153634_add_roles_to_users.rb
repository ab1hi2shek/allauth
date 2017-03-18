class AddRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :roles, :integer, null: false, :default => 0
  end
end
