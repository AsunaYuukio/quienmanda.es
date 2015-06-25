class CreateMojepanstwoPlDeputies < ActiveRecord::Migration
  def change
    create_table :mojepanstwo_pl_deputies do |t|
      t.string :_id, limit: 255
      t.string :_mpurl, limit: 255

      t.boolean :mandat_wygasl, null: false
      t.string :sejm_kluby_nazwa, limit: 128
      t.string :sejm_kluby_skrot, limit: 32
      t.string :imie_pierwsze, limit: 64, null: false
      t.string :imie_drugie, limit: 64
      t.string :nazwisko, limit: 64, null: false
      t.string :plec, limit: 1
      t.integer :krs_osoba_id

      t.timestamps
    end
  end
end
