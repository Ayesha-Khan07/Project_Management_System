class ConvertProjectStatusToIntegerInProjects < ActiveRecord::Migration[8.0]

  STRING_TO_INT = {
    "pending"   => 0,
    "working"   => 1,
    "completed" => 2
  }

  def change
    # 1) Add new integer column temporarily
    add_column :projects, :project_status_int, :integer

    # 2) Backfill using the string values
    if column_exists?(:projects, :project_status)
      say_with_time "Backfilling project_status_int from project_status (string)" do
        Project.reset_column_information
        Project.find_each do |p|
          raw_val = p.read_attribute(:project_status)
          int_val = STRING_TO_INT[raw_val.to_s] || 0
          p.update_column(:project_status_int, int_val)
        end
      end
    end

    # 3) Remove old string column
    remove_column :projects, :project_status

    # 4) Rename new integer column to final name
    rename_column :projects, :project_status_int, :project_status

    # 5) Apply default + constraint
    change_column_default :projects, :project_status, 0
    change_column_null :projects, :project_status, false
  end
end
