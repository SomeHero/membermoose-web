class AddSiteUrlToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :site_url, :string
  end
end
