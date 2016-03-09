class User < ActiveRecord::Base

  def debit(amount)
    self.balance = (self.balance -= amount)
  end

  def credit(amount)
    self.balance = (self.balance += amount)
  end

end