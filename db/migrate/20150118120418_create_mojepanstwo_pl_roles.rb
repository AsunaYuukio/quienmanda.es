class CreateMojepanstwoPlRoles < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_roles do |t|
      t.references :krs_person, index: true
      t.references :krs_organization, index: true
      t.string :function, limit: 255
      t.boolean :canceled
      
      t.references :relation, index: true

      t.timestamps
    end
    
    add_index(
      :mojepanstwo_pl_roles, 
      [:krs_person_id, :krs_organization_id, :function], 
      unique: true, 
      name: 'unique_role'
    )
  end
end
