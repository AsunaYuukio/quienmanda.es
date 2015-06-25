class AddNameToMojepanstwoPlPublicOrders < ActiveRecord::Migration
  def change
    add_column :mojepanstwo_pl_public_orders, :name, :string
  end
end
