class CreateMojepanstwoPlKrsOrganizations < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_krs_organizations do |t|
      t.string :_id, limit: 255
      t.string :_mpurl, limit: 255
      t.string :nazwa, limit: 255
      t.integer :krs
      
      t.references :entity, index: true

      t.timestamps
    end
    
    add_index :mojepanstwo_pl_krs_organizations, :_id, unique: true
    add_index :mojepanstwo_pl_krs_organizations, :_mpurl, unique: true
    add_index :mojepanstwo_pl_krs_organizations, :krs, unique: true
  end
end
