# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :monday, :at => '1am' do
  rake "przeswietl:import_missing_pesels"
end
every :tuesday, :at => '2am' do
  rake "przeswietl:import_current_relations"
end
every :wednesday, :at => '3am' do
  rake "przeswietl:import_historic_relations"
end

every :thursday, :at => '1am' do
  rake "przeswietl:import_missing_pesels"
end
every :friday, :at => '2am' do
  rake "przeswietl:import_current_relations"
end
every :saturday, :at => '3am' do
  rake "przeswietl:import_historic_relations"
end