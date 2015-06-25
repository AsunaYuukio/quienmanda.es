class CreateMojepanstwoPlKrsPeople < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_krs_people do |t|
      t.string :_id
      t.string :_mpurl
      t.string :imie_pierwsze, limit: 64
      t.string :imie_drugie, limit: 64
      t.string :nazwisko, limit: 64

      t.timestamps
    end

    add_index :mojepanstwo_pl_krs_people, :_id, unique: true
    add_index :mojepanstwo_pl_krs_people, :_mpurl, unique: true
  end
end
