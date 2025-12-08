class CreateProjectsUsers < ActiveRecord::Migration[6.0]   # 6.0 not 8.0
  def change
    # Stop execution if table already exists
    return if table_exists?(:projects_users)

    create_table :projects_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end

    # Add index only if it's not present
    unless index_exists?(:projects_users, [:project_id, :user_id])
      add_index :projects_users, [:project_id, :user_id], unique: true
    end
  end
end
