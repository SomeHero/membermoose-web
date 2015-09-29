class CreateStripeWebhooks < ActiveRecord::Migration
  def change
    create_table :stripe_webhooks do |t|
      t.string :stripe_id

      t.timestamps
    end
  end
end
