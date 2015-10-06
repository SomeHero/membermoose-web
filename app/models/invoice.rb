class Invoice < ActiveRecord::Base
  belongs_to :subscription

end
