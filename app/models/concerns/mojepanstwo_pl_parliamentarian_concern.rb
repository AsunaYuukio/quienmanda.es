module MojepanstwoPlParliamentarianConcern
  extend ActiveSupport::Concern

  included do
    validates :imie_pierwsze, presence: true, length: { maximum: 64 }
    validates :imie_drugie, length: { maximum: 64 }
    validates :nazwisko, presence: true, length: { maximum: 64 }
  end

  def get_name
    result = imie_pierwsze
    result += ' ' + imie_drugie if imie_drugie && ! imie_drugie.empty?
    result + ' ' + nazwisko
  end

  def build_krs_person
    if krs_osoba_id > 0 && ! person.krs_person
      person.build_krs_person id: krs_osoba_id
    end
  end

  private

  def get_short_name
    "#{imie_pierwsze} #{nazwisko}"
  end

  def find_person
    MojepanstwoPlKrsPerson.find_by(id: krs_osoba_id).try :person
  end
end
