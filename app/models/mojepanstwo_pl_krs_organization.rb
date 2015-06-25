class MojepanstwoPlKrsOrganization < ActiveRecord::Base
  include MojepanstwoPlDataobjectConcern
  include EntitySourceConcern

  has_many :roles, class_name: 'MojepanstwoPlRole', foreign_key: 'krs_organization_id'
  has_many :krs_people, through: :roles

  validates :krs, uniqueness: true

  def self.import id
    if krs_organization = find_by(id: id)
      krs_organization.import
    else
      require "#{Rails.root}/vendor/mojepanstwo.pl/krs_podmiot.rb"
      create! dataobject_translate Mojepanstwo_pl::KrsPodmiot.get id
    end
  end

  def import
    require "#{Rails.root}/vendor/mojepanstwo.pl/krs_podmiot.rb"
    data = Mojepanstwo_pl::KrsPodmiot.get id
    update! self.class.dataobject_translate data
    self
  end

  def get_name
    nazwa
  end

  private

  def self.dataobject_translate mp_object
    { 'id'     => mp_object['object']['id'],
      '_id'    => mp_object['object']['_id'],
      '_mpurl' => mp_object['object']['_mpurl'],
      'nazwa'  => mp_object['object']['data']['krs_podmioty.nazwa'],
      'krs'  => mp_object['object']['data']['krs_podmioty.krs']
    }
  end

  def get_description
    "Podmiot KRS nr: #{krs}"
  end

  def person?
    false
  end

end
