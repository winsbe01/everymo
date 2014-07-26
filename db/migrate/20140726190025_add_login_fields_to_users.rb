class AddLoginFieldsToUsers < ActiveRecord::Migration
  def change
	add_column :users, :password, :string
	add_column :users, :salt, :string
  end
end
