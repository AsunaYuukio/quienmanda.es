class MojepanstwoPlKrsPerson < ActiveRecord::Base
  include MojepanstwoPlDataobjectConcern
  include MojepanstwoPlHasPersonConcern
  include EntitySourceConcern

  has_one :person, class_name: 'MojepanstwoPlPerson', foreign_key: 'krs_person_id'
  has_many :roles, class_name: 'MojepanstwoPlRole', foreign_key: 'krs_person_id'
  has_many :krs_organizations, through: :roles

  def self.import id
    if krs_person = find_by(id: id)
      krs_person.import
    else
      require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoba.rb"
      create dataobject_translate Mojepanstwo_pl::KrsOsoba.get id
    end
  end

  def import
    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoba.rb"
    if data = Mojepanstwo_pl::KrsOsoba.get(id)
      update_attributes self.class.dataobject_translate data
    end
  end

#  def get_roles
#    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoba.rb"
#    data = Mojepanstwo_pl::KrsOsoba.get_layer id, 'organizacje'
#    data.each do |organization|
#      org_object = MojepanstwoPlKrsOrganization.import organization['id']
#      organization['role'].each do |role|
#        role_object = roles.build(
#          krs_organization: org_object,
#          function: role["label"],
#          canceled: organization['wykreslony']
#        )
#      end
#    end
#  end

  def import_roles
    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoba.rb"
    data = Mojepanstwo_pl::KrsOsoba.get_layer id, 'organizacje'
    data.each do |organization|
      org_object = MojepanstwoPlKrsOrganization.import organization['id']
      organization['role'].each do |role|
        existing_role = roles.where(:krs_organization => org_object).first
        if existing_role
          existing_role.update_attributes(
            function: role["label"],
            canceled: organization['wykreslony']
          )
        else
          roles.create!(
            krs_organization: org_object,
            function: role["label"],
            canceled: organization['wykreslony']
          )
        end
      end
    end
  end

  def get_organizations_id
    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoba.rb"
    data = Mojepanstwo_pl::KrsOsoba.get_layer id, 'organizacje'
    data.map { |org_data| org_data["id"] }
  end

  def get_name
    result = imie_pierwsze
    result += ' ' + imie_drugie if imie_drugie && ! imie_drugie.empty?
    result + ' ' + nazwisko
  end

  def self.search_krs first_name, last_name
    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_osoby.rb"
    data = Mojepanstwo_pl::KrsOsoby.search first_name, last_name
    data.map do |person_data|
      new dataobject_translate('object' => person_data)
    end
  end

  private

  def self.dataobject_translate mp_object
    { 'id'     => mp_object['object']['id'],
      '_id'    => mp_object['object']['_id'],
      '_mpurl' => mp_object['object']['_mpurl'],
      'imie_pierwsze' => mp_object['object']['data']['krs_osoby.imie_pierwsze'],
      'imie_drugie'   => mp_object['object']['data']['krs_osoby.imie_drugie'],
      'nazwisko'      => mp_object['object']['data']['krs_osoby.nazwisko']
    }
  end

  def find_person
    MojepanstwoPlDeputy.find_by(krs_osoba_id: id).try :person
  end

end
