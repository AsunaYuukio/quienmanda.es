class MojepanstwoPlDeputy < ActiveRecord::Base
  include MojepanstwoPlDataobjectConcern
  include MojepanstwoPlParliamentarianConcern
  include MojepanstwoPlHasPersonConcern

  validates :sejm_kluby_nazwa, length: { maximum: 128 }
  validates :sejm_kluby_skrot, length: { maximum: 32 }
  validates :plec, inclusion: { in: ['K', 'M'] }

  has_one :person, class_name: MojepanstwoPlPerson, foreign_key: :deputy_id

  def self.import_all
    require "#{Rails.root}/vendor/mojepanstwo.pl/poslowie.rb"
    Mojepanstwo_pl::Poslowie.get.each do |mp_deputy|
      deputy = find_or_initialize_by id: mp_deputy['id']
      deputy.update_attributes dataset_translate mp_deputy
    end
  end

  def self.update_all_entities
    all.each do |deputy|
      deputy.try(:person).try(:setup_entity)
    end
  end

  def get_description
    mandat_wygasl ? "Były poseł." : "Poseł."
  end

  def mojepanstwo_photo_url
    full_url = Net::HTTP.get_response(URI(_mpurl)).to_hash["location"].first
    html = Net::HTTP.get(URI(full_url))
    Nokogiri::XML(html).css('.objectRender .thumb_cont img.thumb').first["src"]
  end

  private

  def self.dataset_translate mp_object
    { 'id'     => mp_object['id'],
      '_id'    => mp_object['_id'],
      '_mpurl' => mp_object['_mpurl'],
      'sejm_kluby_nazwa' => mp_object['data']['sejm_kluby.nazwa'],
      'sejm_kluby_skrot' => mp_object['data']['sejm_kluby.skrot'],
      'mandat_wygasl'    => mp_object['data']['poslowie.mandat_wygasl'].to_i == 1,
      'imie_pierwsze'    => mp_object['data']['poslowie.imie_pierwsze'],
      'imie_drugie'      => mp_object['data']['poslowie.imie_drugie'],
      'nazwisko'         => mp_object['data']['poslowie.nazwisko'],
      'plec'             => mp_object['data']['poslowie.plec'],
      'krs_osoba_id'     => mp_object['data']['poslowie.krs_osoba_id'].to_i,
      'data_urodzenia'   => Date.parse(mp_object['data']['poslowie.data_urodzenia']),
      'frekwencja'       => mp_object['data']['poslowie.frekwencja'],
      'zawod'            => mp_object['data']['poslowie.zawod'],
    }
  end
end
