class CreateMojepanstwoPlPeople < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_people do |t|
      t.integer :krs_person_id
      t.integer :deputy_id
      t.references :entity, index: true

      t.timestamps
    end
    add_index :mojepanstwo_pl_people, :krs_person_id, unique: true
    add_index :mojepanstwo_pl_people, :deputy_id, unique: true
  end
end
