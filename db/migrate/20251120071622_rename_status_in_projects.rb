class RenameStatusInProjects < ActiveRecord::Migration[8.0]
  def change
    rename_column :projects, :status, :project_status
  end
end
