require ::File.expand_path('../config/environment',  __FILE__)
use Rack::RubyProf, :path => './tmp/profile' if Rails.env.profile?
use Rack::Deflater  # gzip compression
run Rails.application

#require 'rack/lobster'
#
#map '/health' do
#  health = proc do |env|
#    [200, { "Content-Type" => "text/html" }, ["1"]]
#  end
#  run health
#end

