class CreateTransactions < ActiveRecord::Migration[5.2]
    def change
        create_table :transfers do |t|
            t.integer :shares
            t.decimal :amount
            t.boolean :is_sell
      
            t.timestamps null: false
        end
    end
end