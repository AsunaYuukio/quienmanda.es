require "#{Rails.root}/vendor/przeswietl/przeswietl.rb"
require "#{Rails.root}/lib/import_log.rb"

class ImportPersonData
  def initialize(ids = nil)
    if ids
      @scope = Entity.where(:id => [ids].flatten)
    else
      @scope = Entity.people
    end
    @result = ""
  end

  def log(string)
    ImportLog.log(string)
    @result += string
    @result += "\n"
  end

  def import_missing_pesels
    log "\n\n\n\nIMPORT_MISSING_PESELS"

    pesels_found = 0
    pesels_not_found = 0
    scope = @scope.without_pesel
    total = scope.count

    scope.all.each_with_index do |entity, i|
      entity.touch_imported_at!
      log "#{i+1}/#{total} #{entity.short_or_long_name}"
      json = Przeswietl::API.new('searchPerson', [entity.name]).call
      json.select! { |j| j["pesel"].to_s.to_i > 0}

      pesel = nil
      if json.count > 1
        if entity.birth_date
          pesel_birth_date = entity.birth_date.strftime('%y%m%d')
          found_json = json.find { |data| data["pesel"].match(/^#{pesel_birth_date}/)}
          if found_json
            pesel = found_json["pesel"]
          end
        end
      elsif json.count == 1
        pesel = json.first["pesel"]
      end

      if pesel
        log "  pesel updated (#{pesels_found += 1})"
        entity.update_attribute(:pesel, pesel)
      else
        log "  person not found (#{pesels_not_found += 1})"
      end
    end

    log "entities_scanned: #{total}"
    log "pesels_found: #{pesels_found}"
    log "pesels_not_found: #{pesels_not_found}"
  end

  def import_historic_relations
    log "\n\n\n\nIMPORT_HISTORIC_RELATIONS"

    found_count = 0
    ignored_count = 0
    api_errors_count = 0
    scope = @scope.with_pesel
    total = scope.count

    scope.all.each_with_index do |entity, i|
      entity.touch_imported_at!
      log "#{i+1}/#{total} #{entity.short_or_long_name}"

      begin
        json = Przeswietl::API.new('getPersonHistory', [entity.pesel]).call
      rescue
        log "  API ERROR (#{api_errors_count += 1})"
        next
      end

      log "  found #{json.count} relations"
      json.each do |data|
        relation_type_description = data["role"]
        if relation_type_description.to_s == ""
          relation_type_description = "?"
        end
        relation_type_description = Relation.normalize(relation_type_description)

        org_name = data["company"]["name"]
        org_name = Relation.normalize(org_name)
        org_krs = data["company"]["krs"]
        org_nip = data["company"]["nip"]
        org_regon = data["company"]["regon"]

        if data["from"]
          from = data["from"]
        else
          from = nil
        end

        if data["to"] && Date.parse(data["to"]) < 7.days.ago
          to = data["to"]
        else
          to = nil
        end

        log "  organization: #{org_name}"
        if ImportBlacklist.where(:object_type => "Organization", :object_name => org_name).exists?
          log "  ignored"
          ignored_count += 1
        else
          Relation.import_relation(entity, org_name, relation_type_description, org_krs, org_nip, org_regon, from, to)
          found_count += 1
        end
      end
    end

    log "total: #{total}"
    log "ignored_count: #{ignored_count}"
    log "found_count: #{found_count}"
    log "api_errors_count: #{api_errors_count}"
  end

  def import_current_relations
    log "\n\n\n\nIMPORT_CURRENT_RELATIONS"
    found_count = 0
    ignored_count = 0
    not_found_count = 0
    api_errors_count = 0
    scope = @scope.with_pesel
    total = scope.count

    scope.all.each_with_index do |entity, i|
      entity.touch_imported_at!
      log "#{i+1}/#{total} #{entity.short_or_long_name}"

      begin
        json = Przeswietl::API.new('getPerson', [entity.pesel]).call
      rescue
        log "  API ERROR (#{api_errors_count += 1})"
        next
      end

      json_relations = json["company"] || []

      log "  found #{json_relations.count} relations"
      json_relations.each do |data|

        relation_type_description = data["role"]
        if relation_type_description.to_s == ""
          relation_type_description = "?"
        end
        relation_type_description = Relation.normalize(relation_type_description)

        org_name = data["label"]
        org_krs = data["krs"]
        org_nip = data["nip"]
        org_regon = data["regon"]

        unless org_name
          log "  organization with no name - NOT FOUND"
          not_found_count += 1
          next
        end
        org_name = Relation.normalize(org_name)
        log "  organization: #{org_name}"

        if ImportBlacklist.where(:object_type => "Organization", :object_name => org_name).exists?
          log "  ignored"
          ignored_count += 1
        else
          Relation.import_relation(entity, org_name, relation_type_description, org_krs, org_nip, org_regon)
          found_count += 1
        end
      end
    end

    log "total: #{total}"
    log "ignored_count: #{ignored_count}"
    log "found_count: #{found_count}"
    log "not_found_count: #{not_found_count}"
    log "api_errors_count: #{api_errors_count}"
  end

  def result
    @result
  end
end
