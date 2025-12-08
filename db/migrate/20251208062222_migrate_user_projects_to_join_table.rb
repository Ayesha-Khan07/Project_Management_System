class MigrateUserProjectsToJoinTable < ActiveRecord::Migration[6.0]
  def up
    User.find_each do |user|
      if user.project_id.present?
        execute <<-SQL
          INSERT INTO projects_users (project_id, user_id)
          VALUES (#{user.project_id}, #{user.id})
          ON CONFLICT DO NOTHING;
        SQL
      end
    end
  end

  def down
    # Optional: remove all associations from join table
    execute "DELETE FROM projects_users;"
  end
end
