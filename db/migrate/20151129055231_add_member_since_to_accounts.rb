class AddMemberSinceToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :member_since, :datetime, :default  => Time.now
  end
end
