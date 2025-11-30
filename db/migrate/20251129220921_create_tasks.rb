class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :task_type, null: false, default: 0
      t.integer :task_status, null: false, default: 0
      t.integer :progress, null:false, default:0
      t.date :estimated_deadline
      t.references :project, null: false, foreign_key: true
      t.references :assigned_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
