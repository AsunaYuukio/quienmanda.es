namespace :mp do
  namespace :roles do
    desc "setup roles relations"
    task setup: :environment do
      MojepanstwoPlRole.all.each do |role|
        print "#{role.krs_organization.get_name[0..30]} "
        print "-(#{role.function[0..30]})- "
        print "#{role.krs_person.get_name[0..30]} "
        print "setup relation" if role.setup_relation
        puts
      end
    end
  end
end
