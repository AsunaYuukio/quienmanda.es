class AddNipKrsRegonToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :krs, :string
    add_column :entities, :nip, :string
    add_column :entities, :regon, :string
  end
end
