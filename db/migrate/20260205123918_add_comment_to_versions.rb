class AddCommentToVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :versions, :comment, :string
  end
end
