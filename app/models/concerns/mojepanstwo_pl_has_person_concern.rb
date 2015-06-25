module MojepanstwoPlHasPersonConcern
  extend ActiveSupport::Concern

  included do
    validates :person, presence: true

    before_validation :setup_person
  end
  
  private
  def setup_person
    self.person ||= find_person || create_person!
  end
end