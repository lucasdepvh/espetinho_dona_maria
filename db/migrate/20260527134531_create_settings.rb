class CreateSettings < ActiveRecord::Migration[8.1]
  def change
    create_table :settings do |t|
      t.string :establishment_name, null: false
      t.string :phone
      t.string :kitchen_whatsapp
      t.text :address
      t.decimal :default_delivery_fee, precision: 10, scale: 2, default: 0, null: false
      t.text :default_final_message

      t.timestamps
    end
  end
end
