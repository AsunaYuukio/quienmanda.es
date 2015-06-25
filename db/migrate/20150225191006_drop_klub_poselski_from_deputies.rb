class DropKlubPoselskiFromDeputies < ActiveRecord::Migration
  def change
    remove_column :mojepanstwo_pl_deputies, :klub_poselski
  end
end
