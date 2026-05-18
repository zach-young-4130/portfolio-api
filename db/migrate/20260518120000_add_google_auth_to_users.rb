class AddGoogleAuthToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :name, :string
    add_column :users, :avatar_url, :string
    add_column :users, :role, :string, default: "user", null: false

    add_index :users, :google_uid, unique: true
    add_index :users, :role

    # Google-only users won't have a password. Existing rows already have one.
    change_column_null :users, :password_digest, true
  end
end
