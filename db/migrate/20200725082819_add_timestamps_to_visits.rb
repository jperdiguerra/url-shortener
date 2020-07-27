class AddTimestampsToVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :created_at, :datetime, null: false
    add_column :visits, :updated_at, :datetime, null: false
  end
end
