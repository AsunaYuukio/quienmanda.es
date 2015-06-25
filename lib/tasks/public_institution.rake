namespace :mp do
  namespace :public_institution do
    desc "setup public orders entities"
    task setup: :environment do
      path = "https://api-v2.mojepanstwo.pl/dane/instytucje/"
      
      in_db = 0
      (1..15000).each do |index|
        progress = ((index)/15000.0) * 100
        url = path + "#{index}"
        begin
          data = open(url, 'r').read
          parsed = JSON.parse data
          parsed = parsed["Dataobject"]
          unless(parsed.empty?)
            dataset = parsed["dataset"]
            parsed_data = parsed["data"]
      
            id = parsed_data["#{dataset}.id"]
            slug = parsed["slug"]
            nazwa = parsed_data["#{dataset}.nazwa"]
          
            if(Entity.find_by_name(nazwa))
              puts "already in db"
            else
              n = Entity.new(name: nazwa, description: "Instytucja Publiczna", slug: slug, person: false, priority: '1')
              if n.save
                in_db += 1
                puts "#{progress.round(2)}% - #{in_db} - #{n.name}"
              else
                puts "#{progress.round(2)}% - #{in_db} - #{n.errors.full_messages}"
              end
            end
          
            
          end
        rescue => error
          puts error
        end
      end
      
    end
    
    task delete: :environment do
      Entity.where(description: "Instytucja Publiczna").delete_all
    end
    
    task delete_empty_relations: :environment do
      counter = 0
      Relation.all.each do |r|
        if r.target.nil? or r.source.nil?
          counter += 1
          puts r.to_s
          r.delete
        end
      end
      puts "deleted relations: #{counter}"
    end
  end
end