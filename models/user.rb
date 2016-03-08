class User < ActiveRecord::Base

  has_one :account

  def create_account
    Account.create(user_id: self.id, balance: 0.0)
  end

  def credit(amount)
    create_account unless self.account
    account.update(balance: self.account.balance += amount)
  end

  def debit(amount)
    account.update(balance: self.account.balance -= amount)
  end

end