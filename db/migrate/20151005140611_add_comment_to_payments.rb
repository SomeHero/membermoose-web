class AddCommentToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :comments, :string
  end
end
