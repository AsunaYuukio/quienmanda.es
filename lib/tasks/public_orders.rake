namespace :mp do
  namespace :public_orders do
    desc "setup public orders entities"
    task setup: :environment do
      path = "https://api-v2-test.mojepanstwo.pl/dane/zamowienia_publiczne_dokumenty/index?conditions[zamowienia_publiczne_dokumenty.typ_id]=3"
      krs_path="https://api-v2.mojepanstwo.pl/dane/krs_podmioty"
      
      index = 1
      total_pages = 5000
      created_relations = 0
      created_entities = 0
      short = "zamowienia_publiczne_dokumenty"
      
      while index <= total_pages do
        begin
          url = "#{path}&page=#{index}"
          data = open(url, 'r').read
          parsed = JSON.parse data
        
          parsed["Dataobject"].each do |order|
            nazwa_zamowienia = order["data"]["#{short}.nazwa"]
            nazwa_zamawiajacy = order["data"]["zamowienia_publiczne_dokumenty.zamawiajacy_nazwa"]
        
                                                    # LOOP THROUGH EACH ORDER EXECUTOR
          
            order["static"]["wykonawcy"].each do |wykonawca|
              krs_id = wykonawca["krs_id"]
              if krs_id.to_i > 0
                krs_url="#{krs_path}/#{krs_id}"
                krs_data = JSON.parse open(krs_url, 'r').read
                krs = krs_data["Dataobject"]["data"]["krs_podmioty.krs"]
              
                if Entity.find_by_name(nazwa_zamawiajacy)
                  zamawiajacy = Entity.find_by_name(nazwa_zamawiajacy)
                else 
                  zamawiajacy = Entity.create!(name: nazwa_zamawiajacy, priority: '2', published: false, person: false, notes: "zamówienia publiczne")
                  created_entities += 1
                end
              
                if Entity.find_by_krs(krs)
                  wykonawca_conf = Entity.find_by_krs(krs)
                else
                  wykonawca_conf = Entity.create!(name: wykonawca["nazwa"], priority: '2', published: false, person: false, krs: krs, notes: "zamówienia publiczne")
                  created_entities +=1
                end
              
                rel = RelationType.where(description: nazwa_zamowienia.truncate(50)).first || RelationType.create!(description: nazwa_zamowienia.truncate(50))
                if(Relation.where("source_id = #{zamawiajacy.id} and target_id = #{wykonawca_conf.id} and relation_type_id = #{rel.id}").count == 0)
                  Relation.create!(source_id: zamawiajacy.id, target_id: wykonawca_conf.id, relation_type_id: rel.id, notes: nazwa_zamowienia)
                  created_relations +=1
                end
              end
            end
            puts "utworzone instytucje: #{created_entities}, utworzone relacje: #{created_relations}"
            puts "wykonano " + index.to_s + " stron"
          end
          index += 1
        rescue => error
          puts error
          index += 1
        end
        
      end
      
    end
  end
end