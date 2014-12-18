class RenamePortalToTenant < ActiveRecord::Migration
  def change
    rename_column :portals, :url, :subdomain
    rename_column :users, :portal_id, :tenant_id
    rename_column :requests, :portal_id, :tenant_id
    rename_table :portals, :tenants
  end
end
