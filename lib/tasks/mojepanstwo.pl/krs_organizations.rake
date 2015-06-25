namespace :mp do
  namespace :krs_organizations do
    desc "setup krs_organization entities"
    task setup: :environment do
      total = MojepanstwoPlKrsOrganization.count
      MojepanstwoPlKrsOrganization.all.each_with_index do |organization, i|
        print "#{i}/#{total} #{organization.get_name}"
        print " setup entity" if organization.setup_entity
        puts
      end
    end
  end
end
