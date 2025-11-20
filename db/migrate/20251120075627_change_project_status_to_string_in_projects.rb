class ChangeProjectStatusToStringInProjects < ActiveRecord::Migration[8.0]
  def up
    change_column :projects, :project_status, :string, default: "pending"
  end

  def down
    change_column :projects, :project_status, :integer, default: 0
  end
end
