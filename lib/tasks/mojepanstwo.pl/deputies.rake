require 'open-uri'

namespace :mp do
  namespace :deputies do
    desc "Import deputies data from mojepanstwo.pl"
    task import: :environment do
      MojepanstwoPlDeputy.import_all
    end

    task import_photos: :environment do
      total = MojepanstwoPlDeputy.count
      MojepanstwoPlDeputy.all.each_with_index do |deputy, i|
        print "#{i}/#{total} "
        entity = deputy.person.try(:entity)
        unless entity
          puts "no entity"
          next
        end
        unless entity.avatar.file.nil?
          puts "already has photo"
          next
        end

        photo_url = deputy.mojepanstwo_photo_url
        if photo_url
          begin
            filename = photo_url.split('/').last
            File.delete(filename) if File.exists?(filename)
            File.open(filename, 'wb') { |file| file.write(open(photo_url).read) }
            file = File.open(filename)
            entity.avatar = file
            entity.save!
            puts "ok"
            File.delete(filename) if File.exists?(filename)
          rescue OpenURI::HTTPError
            puts "404"
          end
        else
          puts "-"
        end
      end
      MojepanstwoPlDeputy.first.person.entity
    end

    desc "Import deputies krs roles"
    task import_roles: :environment do
      total = MojepanstwoPlDeputy.where('krs_osoba_id > 0').count
      MojepanstwoPlDeputy.where('krs_osoba_id > 0').each_with_index do |deputy, i|
#        begin
          print "#{i}/#{total} Deputy #{deputy.get_name}, "
          unless deputy.person.krs_person
            deputy.build_krs_person
            print "build krs person, "
          end
          if deputy.person.krs_person.import
            print "imported krs data, "
            deputy.person.krs_person.import_roles
            print"imported roles"
          end
          puts
#        rescue Exception => e
#          puts " something goes wrong"
#          puts e.message
#          puts e.backtrace.inspect
#        end
      end
    end
  end
end
