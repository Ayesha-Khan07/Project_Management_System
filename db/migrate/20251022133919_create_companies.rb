class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :services
      t.string  :subscription_status, default: 'free', null: false
      t.integer :member_limit, default: 7, null: false
      t.timestamps
    end
  end
end
