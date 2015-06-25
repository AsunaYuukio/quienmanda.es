class AddMoreFieldsToMojepanstwoPlDeputy < ActiveRecord::Migration
  def change
    add_column :mojepanstwo_pl_deputies, :data_urodzenia, :date
    add_column :mojepanstwo_pl_deputies, :frekwencja, :integer
    add_column :mojepanstwo_pl_deputies, :klub_poselski, :string
    add_column :mojepanstwo_pl_deputies, :zawod, :string
  end
end
