class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.date :project_deadline

      t.references :company, null: false, foreign_key: true
      t.references :manager, null: false, foreign_key: { to_table: :users }
      t.references :client, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
