namespace :mp do
  namespace :people do
    desc "Setup people entities"
    task setup: :environment do
      MojepanstwoPlPerson.all.each do |person|
        print "#{person.get_name}"
        print " entity setup: #{person.entity.name}" if person.setup_entity
        puts
      end
    end
  end
end