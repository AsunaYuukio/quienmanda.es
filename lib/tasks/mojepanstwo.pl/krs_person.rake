namespace :mp do
  namespace :krs_person do
    desc "find person in krs and import if connected to any existing organization"
    task find_and_import_if_connected: :environment do |t, names|
      first_name = ENV["first_name"] || names.first
      last_name = ENV["last_name"] || names.last
      print "search for #{first_name} #{last_name},"
      krs_people = MojepanstwoPlKrsPerson.search_krs first_name, last_name
      krs_people.each do |krs_person|
        print " found #{krs_person.get_name},"
        if MojepanstwoPlKrsOrganization.where(id: krs_person.get_organizations_id).any?
          print " there are connections :-),"
          krs_person.save!
          print " person saved,"
          krs_person.import_roles
          print " roles imported"
        else
          print " there are no connections"
        end
        puts
      end
    end
  end
end