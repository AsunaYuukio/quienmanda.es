class ImportBlacklist < ActiveRecord::Base
  OBJECT_TYPES = ['Organization']
  validates :object_type, presence: true, inclusion: {in: OBJECT_TYPES}
  validates :object_name, presence: true
end
