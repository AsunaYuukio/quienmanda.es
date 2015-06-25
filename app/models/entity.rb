class Entity < ActiveRecord::Base
  has_many :annotations, dependent: :delete_all
  has_many :related_photos, through: :annotations, source: :photo

  has_many :relations_as_source, foreign_key: :source_id, class_name: Relation, inverse_of: :source, dependent: :destroy
  has_many :relations_as_target, foreign_key: :target_id, class_name: Relation, inverse_of: :target, dependent: :destroy

  has_many :mentions, as: :mentionee, inverse_of: :mentionee, dependent: :delete_all
  has_many :related_posts, -> { order('published_at desc') }, through: :mentions, source: :post

  has_paper_trail :ignore => [:imported_at]

  include PgSearch
  multisearchable :against => [:name, :short_name, :description], :if => :published?

  mount_uploader :avatar, AvatarUploader

  # Note: sync_url=true won't work here, because we are using a function (short_or_long_name),
  # so acts_as_url (Stringex) can't detect when the attribute has changed. Bug or feature?
  acts_as_url :short_or_long_name, url_attribute: :slug, only_when_blank: true
  def to_param
    slug
  end

  # Priorities
  PRIORITIES = [PRIORITY_HIGH = '1', PRIORITY_MEDIUM = '2', PRIORITY_LOW = '3']
  def priority_enum
    [ [ 'High', PRIORITY_HIGH ], [ 'Medium', PRIORITY_MEDIUM ], [ 'Low', PRIORITY_LOW ] ]
  end

  validates :name, presence: true, uniqueness: true
  validates :priority, inclusion: {in: PRIORITIES}
  validates :description, length: { maximum: 90 }

  scope :published, -> { where(published: true) }
  scope :people, -> { where(person: true) }
  scope :organizations, -> { where(person: false) }
  scope :with_pesel, -> { where("pesel IS NOT NULL AND pesel != ''") }
  scope :without_pesel, -> { where("pesel IS NULL OR pesel = ''") }
  scope :without_krs, -> { where("krs IS NULL OR krs = ''") }
  
  after_destroy :delete_nil_relations
  
  def delete_nil_relations
    self.relations.each do |r|
      if r.target.nil? || r.source.nil?
        r.destroy!
      end
    end
  end

  # Returns the short name if present, the long one otherwise
  def short_or_long_name
    (short_name.nil? || short_name.blank?) ? name : short_name
  end

  def touch_imported_at!
    update_attribute(:imported_at, Time.now)
  end

  # Returns all the relations an entity is involved in.
  #   This is cleaner than prefetching relations_as_source, adding to relations_as_source...
  def relations
    Relation.where('source_id = ? or target_id = ?', self, self)
            .includes(:facts, :relation_type, :source, :target)
  end

  def to_s
    short_or_long_name
  end

  def age
    return nil unless birth_date
    Time.now.year - birth_date.year
  end

  def delete_and_blacklist
    unless ImportBlacklist.where(:object_type => "Organization", :object_name => self.name).exists?
      ImportBlacklist.create!(:object_type => "Organization", :object_name => self.name)
    end
    annotations.map(&:destroy)
    relations_as_source.map(&:destroy)
    relations_as_target.map(&:destroy)
    self.destroy
    true
  end
end
