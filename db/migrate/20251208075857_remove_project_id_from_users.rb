class RemoveProjectIdFromUsers < ActiveRecord::Migration[8.0]
  def change
    #remove project_id col from user table as it is creating conflict in many-to-many thing
    remove_column :users, :project_id, :bigint
  end
end
