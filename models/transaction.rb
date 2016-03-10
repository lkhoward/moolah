class Transaction < ActiveRecord::Base

  def from
    User.find_by_email(self.from_email)
  end

  def to
    User.find_by_email(self.to_email)
  end

end