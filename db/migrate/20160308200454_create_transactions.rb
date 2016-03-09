class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :from_email
      t.integer :to_email
      t.float :amount
      t.timestamps
    end
  end
end
