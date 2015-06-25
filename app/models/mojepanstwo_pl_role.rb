class MojepanstwoPlRole < ActiveRecord::Base
  belongs_to :krs_person, class_name: 'MojepanstwoPlKrsPerson'
  belongs_to :krs_organization, class_name: 'MojepanstwoPlKrsOrganization'
  belongs_to :relation

  validates_uniqueness_of :function, scope: [:krs_person, :krs_organization]
  validates :krs_person, :krs_organization, :function, presence: true

  def setup_relation
    if relation

    elsif krs_person.person.entity && krs_organization.entity
      create_relation(
        source: krs_person.person.entity,
        target: krs_organization.entity,
        relation_type: get_or_create_relation_type,
        published: true
      )
    end
  end

  private

  def get_or_create_relation_type
    RelationType.find_by(description: function) || RelationType.create(description: function)
  end
end
