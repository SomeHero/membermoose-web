class PaymentProcessor < ActiveRecord::Base
  def as_json(options={})
  {
    :name => self.name,
  }
  end
end
