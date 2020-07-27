class AddUserTypesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :paid, :boolean, default: false
  end
end
