class ChangeTransactions < ActiveRecord::Migration
  def change
    change_column(:transactions, :from_email, :string)
    change_column(:transactions, :to_email, :string)
  end
end
