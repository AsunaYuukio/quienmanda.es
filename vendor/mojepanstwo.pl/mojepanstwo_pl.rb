require 'json'
require 'open-uri'

module Mojepanstwo_pl class Mojepanstwo_pl
  API_URL = 'http://api.mojepanstwo.pl'

  def self.get path, params={}
    url = make_url path, params
    data = open(url, 'r').read
    JSON.parse data
  end

  private
  def self.make_url path, params={}
    query = params.map do |param, value|
      case value
      when Array
        value.map{ |array_item| "#{param}[]=#{array_item}" }.join('&')
      when Hash
        value.map{ |param_key, param_val| "#{param}[#{param_key}]=#{param_val}" }.join('&')
      else
        "#{param}=#{value}"
      end
    end
    URI::encode "#{API_URL}/#{path}?#{query.join '&'}"
  end
end end
