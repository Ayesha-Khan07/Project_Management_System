class MakeManagerAndClientNullableInProjects < ActiveRecord::Migration[8.0]
  def change
    change_column_null :projects, :manager_id, true
    change_column_null :projects, :client_id, true
  end
end
