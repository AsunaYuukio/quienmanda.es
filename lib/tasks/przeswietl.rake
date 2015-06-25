namespace :przeswietl do
  desc "Imports data from przeswietl.pl"

  task import_missing_pesels: :environment do
    binding.pry
    ImportPersonData.new.import_missing_pesels
  end

  task import_historic_relations: :environment do
    ImportPersonData.new.import_historic_relations
  end

  task import_current_relations: :environment do
    ImportPersonData.new.import_current_relations
  end
end
