class DropUsersTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :username
      t.string :role
      t.string :status
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
