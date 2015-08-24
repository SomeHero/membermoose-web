class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :phone_number
      t.references :address, index: true
      t.string :type

      t.timestamps
    end
  end
end
