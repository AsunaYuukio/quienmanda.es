class AddIsOrderToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :is_order, :boolean
  end
end
