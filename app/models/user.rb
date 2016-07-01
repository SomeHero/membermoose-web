class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  has_many :accounts
  attr_accessor :account
  has_one :account
  accepts_nested_attributes_for :account
  #accepts_nested_attributes_for :account, :update_only => true
  #validates_associated :account

  def as_json(options={})
  {
    :id => self.id,
    :email => self.email,
    :account => self.account,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end
