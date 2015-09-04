class AddAttachmentPhotoToAccounts < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :accounts, :photo
  end
end
