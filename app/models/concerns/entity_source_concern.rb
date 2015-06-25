module EntitySourceConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :entity
  end

  def setup_entity option={}
    data = entity_data
    if entity
      entity.update_attributes data
      x = 1
      until entity.valid? || x > 100
        entity.name = data[:name] + " (#{x+=1})"
      end
      save!
      entity.previous_changes.any?
    else
      build_entity data
      x = 1
      until entity.valid? || x > 100
        entity.name = data[:name] + " (#{x+=1})"
      end
      save!
      true
    end
  end

  private

  def entity_data
    { name: get_name,
      priority: Entity::PRIORITY_MEDIUM,
      description: get_description,
      published: 1,
      person: person?,
      club_name: try(:deputy).try(:sejm_kluby_nazwa),
      birth_date: try(:deputy).try(:data_urodzenia),
      occupation: try(:deputy).try(:zawod),
      attendance: try(:deputy).try(:frekwencja),
    }
  end

  def person?
    false
  end
end
