class CreateTransactions < ActiveRecord::Migration[5.2]
    def change
        create_table :transactions do |t|
            t.string :symbol
            t.integer :total_shares
            t.decimal :total_price
            t.boolean :is_sell
            t.references :user
      
            t.timestamps null: false
        end
    end
end