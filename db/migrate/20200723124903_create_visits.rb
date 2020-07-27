class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.belongs_to(:url)
      t.string :ip_address
      t.string :http_referrer
    end
  end
end
