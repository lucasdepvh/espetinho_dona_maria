class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false
      t.integer :average_preparation_time

      t.timestamps
    end
  end
end
