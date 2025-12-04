class CreateProjectsUsersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :projects_users, id: false do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end

    # Optional: Add a composite index to prevent duplicate associations
    add_index :projects_users, [:project_id, :user_id], unique: true
  end
end
