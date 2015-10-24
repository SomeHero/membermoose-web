class Charge < ActiveRecord::Base
  belongs_to :card
  belongs_to :payment
end
