class AddIndexToShortCode < ActiveRecord::Migration[5.2]
  def change
    add_index :urls, :short_code
  end
end
