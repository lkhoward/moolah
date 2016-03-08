class Activity < ActiveRecord::Base

  belongs_to :account

  def from
    User.find(self.from_account_id)
  end

  def to
    User.find(self.to_account_id)
  end

end