require 'dalli'

namespace :memcached do
  desc "Clear memcached data"
  task flush: :environment do
    dc = Dalli::Client.new
    dc.flush
    puts "Flushed!"
  end
end
