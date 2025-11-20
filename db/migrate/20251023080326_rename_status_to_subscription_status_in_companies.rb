class RenameStatusToSubscriptionStatusInCompanies < ActiveRecord::Migration[8.0]
  def change
     if column_exists?(:companies, :status)
      rename_column :companies, :status, :subscription_status
     end
  end
end
