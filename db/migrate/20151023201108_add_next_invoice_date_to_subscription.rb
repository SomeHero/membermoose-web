class AddNextInvoiceDateToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :next_invoice_date, :datetime
  end
end
