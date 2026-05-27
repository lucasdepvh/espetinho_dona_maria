class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.integer :order_type, default: 0, null: false
      t.string :table_number
      t.text :delivery_address
      t.integer :payment_method, default: 0, null: false
      t.decimal :change_for, precision: 10, scale: 2
      t.decimal :delivery_fee, precision: 10, scale: 2, default: 0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0, null: false
      t.decimal :total, precision: 10, scale: 2, default: 0, null: false
      t.text :notes
      t.datetime :whatsapp_sent_at
      t.datetime :kitchen_whatsapp_sent_at

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :created_at
  end
end
