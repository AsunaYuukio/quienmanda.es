class CreateMojepanstwoPlPublicInstitutions < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_public_institutions do |t|
      t.string :name
      t.integer :_id
      t.string :slug

      t.timestamps
    end
  end
end
