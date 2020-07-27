class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :short_code, null: false
      t.text :long_url, null: false
      t.date :expiry_date
      t.integer :max_clicks
      t.timestamps
    end
  end
end
