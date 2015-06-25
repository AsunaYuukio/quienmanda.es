class AddIndexToDeputies < ActiveRecord::Migration
  def change
    add_index :mojepanstwo_pl_deputies, :_id, unique: true
    add_index :mojepanstwo_pl_deputies, :_mpurl, unique: true
  end
end
