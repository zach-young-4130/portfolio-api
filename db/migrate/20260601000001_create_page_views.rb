class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.string :path, null: false
      t.string :ip_address
      t.string :user_agent
      t.string :referrer
      t.string :city
      t.string :region
      t.string :country
      t.timestamps
    end

    add_index :page_views, :created_at
    add_index :page_views, :country
    add_index :page_views, :city
  end
end
