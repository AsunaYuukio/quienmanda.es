class CreateMojepanstwoPlPublicOrders < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_public_orders do |t|
      t.string :slug
      t.string :price
      t.integer :status
      t.integer :contractor_id
      t.integer :procurer_id
      t.integer :order_number

      t.timestamps
    end
  end
end
