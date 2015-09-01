class AddAttachmentLogoToAccounts < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :accounts, :logo
  end
end
