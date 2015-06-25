class Relation < ActiveRecord::Base
  belongs_to :source,
              foreign_key: :source_id,
              class_name: Entity,
              inverse_of: :relations_as_source,
              touch: true
  belongs_to :target,
              foreign_key: :target_id,
              class_name: Entity,
              inverse_of: :relations_as_target,
              touch: true
  belongs_to :relation_type, inverse_of: :relations

  has_paper_trail

  has_and_belongs_to_many :facts

  validates :source, :target, :relation_type, presence: true

  scope :published, -> { where(published: true) }

  # Collect all the different sources available (entered manually or automatically)
  def sources
    sources = []
    sources << via unless via.blank?
    sources << via2 unless via2.blank?
    sources << via3 unless via3.blank?
    facts.each {|fact| sources << fact.properties['via'] unless fact.properties['via'].blank? }
    sources
  end

  def to_s
    "#{source && source.short_or_long_name} -> #{relation_type && relation_type.description} -> #{target && target.short_or_long_name}"
  end

  def self.import_relation(person_entity, org_name, relation_type_description, krs = nil, nip = nil, regon = nil, from = nil, to = nil, priority = "1")
    relation_type_description = Relation.normalize(relation_type_description)
    org_name = Relation.normalize(org_name)

    # Can be found as person
    org_entity = Entity.where(:name => org_name).first
    if org_entity
      puts "    org_entity #{org_entity.id} present"
    else
      org_entity = Entity.create!(:person => false, :name => org_name, :published => true, :priority => priority)
      puts "    org_entity #{org_entity.id} created"
    end

    org_entity.krs = krs if krs.to_s.length > 1
    org_entity.nip = nip if nip.to_s.length > 1
    org_entity.regon = regon if regon.to_s.length > 1
    org_entity.save!

    relation_type = RelationType.where(:description => relation_type_description).first
    unless relation_type
      relation_type = RelationType.create!(:description => relation_type_description)
    end

    relation = Relation.where(:source_id => person_entity.id, :target_id => org_entity.id, :relation_type => relation_type).first
    if relation
      puts "    updating relation #{relation.id}"
    else
      relation = Relation.create!(:source_id => person_entity.id, :target_id => org_entity.id, :relation_type => relation_type)
      puts "    created relation #{relation.id}"
    end

    relation.published = true
    relation.from = from
    relation.to = to
    relation.save!
  end

  def self.normalize(string)
    string.downcase.strip.split(" ").map(&:capitalize).join(" ")
  end
  
  
end
