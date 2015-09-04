class AddAttachmentPhotoToPlans < ActiveRecord::Migration
  def self.up
    change_table :plans do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :plans, :photo
  end
end
