class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string
    add_column :users, :role, :string, default: "admin"
    add_reference :users, :company, foreign_key: true, null: true
    add_column :users, :status, :string, default: "inactive"
    add_index :users, :username, unique: true
  end
end
