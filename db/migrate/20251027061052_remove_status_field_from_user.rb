class RemoveStatusFieldFromUser < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :status, :string
  end
end
