class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :from_account_id
      t.integer :to_account_id
      t.string :transaction_type
      t.float :amount
      t.timestamps
    end
  end
end
