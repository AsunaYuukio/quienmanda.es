require "#{Rails.root}/vendor/przeswietl/przeswietl.rb"
require "#{Rails.root}/lib/import_log.rb"

class ImportCompanyData
  def initialize(id)
    if id
      @scope = Entity.where(id: id)
    else
      return "Provide id"
    end
    @result = ""
  end
  
  def log(string)
    ImportLog.log(string)
    @result += string
    @result += "\n"
  end
  
  def import_missing_krs
    log "\n\nIMPORT_MISSING_KRS"

    krs_found = 0
    krs_not_found = 0
    scope = @scope.without_krs
    total = scope.count

    scope.all.each_with_index do |entity, i|
      entity.touch_imported_at!
      log "#{i+1}/#{total} #{entity.short_or_long_name}"
      json = Przeswietl::API.new('searchByName', [entity.name]).call
      json.select! { |j| j["krs"].to_s.to_i > 0}
      
      puts json

      krs = nil
      if json.count == 1
        krs = json.first["krs"]
      elsif json.count > 1
        json.each do |j|
          if j['name'] == entity.name
            krs = j['krs']
          end
        end
      end
      
      if krs
        log " krs updated (#{krs_found += 1})"
        entity.update_attribute(:krs, krs)
      else
        log " krs not found (#{krs_not_found += 1})"
      end
      
    end

    log "entities_scanned: #{total}"
    log "krs_found: #{krs_found}"
    log "krs_not_found: #{krs_not_found}"
  end
  
  def import_heads
    entity = @scope.first
    log "\n\nIMPORT_MANAGEMENT"
    persons_found = 0
    if entity.krs?
      json = Przeswietl::API.new('getKrs', [entity.krs]).call
    else
      return log " no krs provided"
    end
    
    objects = json["objects"]
    
    if !objects.empty?
      
      objects.each do |relation, data|
        rel = RelationType.where(description: relation).first || RelationType.create!(description: relation)
        data.each do |d|
          if en = Entity.find_by_name(d['label'])
            
            if Relation.where(source_id: en.id, target_id: entity.id, relation_type_id: rel.id).empty? && Relation.where(source_id: entity.id, target_id: en.id, relation_type_id: rel.id).empty?
              Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
              log "dodano relację z #{en.name} jako #{rel.description}"
            else
              log "#{en.name} jest już powiązany "
            end
            
          else
            if d["regon"]
              en = Entity.create!(name: d['label'], priority: '2', published: false, person: false, regon: d["regon"])
              if d["nip"]
                en.update_attribute!(:nip, d["nip"])
              end
              Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
              log " dodano #{en.name}(firma) jako #{relation}"
            else
              en = Entity.create!(name: d['label'], priority: '2', published: false, person: true)
              Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
              log " dodano #{en.name} jako #{relation}"
            end
          end
          
        end
      end
      
    end
    
    # if zarzad
#       rel = RelationType.where(description: 'członek zarządu').first || RelationType.create!(description: 'członek zarządu')
#       zarzad.each do |z|
#         if en = Entity.find_by_name(z['label'])
#           if Relation.where(source_id: en.id, target_id: entity.id).empty? && Relation.where(source_id: entity.id, target_id: en.id).empty?
#             Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
#             log "dodano relację z #{en.name}"
#           else
#             log "członek zarządu #{en.name} jest już powiązany"
#           end
#         else
#           en = Entity.create!(name: z['label'], priority: '2', published: false, person: true)
#           Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
#           log " dodano wspólnika: #{en.name}"
#         end
#       end
#     end
#
#     if wspolnicy
#       rel = RelationType.where(description: 'wspólnik').first || RelationType.create!(description: 'wspólnik')
#       wspolnicy.each do |z|
#         if en = Entity.find_by_name(z['label'])
#           if Relation.where(source_id: en.id, target_id: entity.id).empty? && Relation.where(source_id: entity.id, target_id: en.id).empty?
#             Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
#             log " dodano relację z #{en.name}"
#           else
#             log " wspólnik #{en.name} jest już powiązany"
#           end
#         else
#           en = Entity.create!(name: z['label'], priority: '2', published: false, person: true)
#           Relation.create!(source_id: en.id, target_id: entity.id, relation_type_id: rel.id)
#           log " dodano wspólnika: #{en.name}"
#         end
#       end
#     end
    
  end
  
  def result
    @result
  end
end