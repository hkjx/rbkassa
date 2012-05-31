class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.float :price
      t.string :currency
      t.integer :inv_id

      t.timestamps
    end
  end
end
