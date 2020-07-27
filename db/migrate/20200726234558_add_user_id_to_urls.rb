class AddUserIdToUrls < ActiveRecord::Migration[5.2]
  def change
    add_reference :urls, :user, foreign_key: true
  end
end
