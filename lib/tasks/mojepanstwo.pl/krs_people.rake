namespace :mp do
  namespace :krs_people do
    desc "finds people from list and import if connections exiests"
    task import_if_connected: :environment do
      File.
        read('vendor/100richest.txt').
        lines.each do |line|
          names = line.split
          first_name = names.first
          last_name = names.last.chomp.split('-').first
          Rake::Task['mp:krs_person:find_and_import_if_connected'].execute([first_name, last_name])
        end
    end
  end
end
