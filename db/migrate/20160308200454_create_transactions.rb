class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :from_email
      t.string :to_email
      t.float :amount
      t.timestamps
    end
  end
end
