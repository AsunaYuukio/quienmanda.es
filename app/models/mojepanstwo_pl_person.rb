class MojepanstwoPlPerson < ActiveRecord::Base
  include EntitySourceConcern

  belongs_to :entity

  validates :deputy_id, uniqueness: true, allow_blank: true
  validates :krs_person_id, uniqueness: true, allow_blank: true

  belongs_to :deputy, foreign_key: :deputy_id, class_name: :MojepanstwoPlDeputy
  belongs_to :krs_person, foreign_key: :krs_person_id, class_name: :MojepanstwoPlKrsPerson

  def get_name
    (deputy || krs_person).get_name
  end

  private

  def get_description
    description = deputy && deputy.get_description
  end

  def person?
    true
  end
end
