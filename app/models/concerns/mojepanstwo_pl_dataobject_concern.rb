module MojepanstwoPlDataobjectConcern
  extend ActiveSupport::Concern

  included do
    validates :_id, :_mpurl, length: { maximum: 255 }
    validates :_id, :_mpurl, uniqueness: true
  end

  def import

  end
end
