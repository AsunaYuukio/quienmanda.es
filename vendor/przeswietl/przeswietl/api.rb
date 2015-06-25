module Przeswietl
  class API
    PUBLIC_KEY = '808c5a'
    PRIVATE_KEY = '7584907efe71724347e68935d4679041'
    URL = 'http://api.przeswietl.pl/api/v1/'

    attr_reader :method, :params

    def initialize(method, params)
      @method = method
      @params = params
    end

    def call
      timestamp = Time.now.to_i
      md5 = Digest::MD5.new
      md5 << "#{PRIVATE_KEY}#{timestamp}"
      sec = md5.hexdigest

      query = {}
      query['ts'] = timestamp
      query['key'] = PUBLIC_KEY
      query['sec'] = sec
      query['method'] = method
      query['params'] = params

      full_url = URL + '?' + query.to_query
      response = Net::HTTP.get_response(URI(full_url))
      if response.code == "200"
        JSON.parse(response.body)["result"]
      else
        raise "ERROR #{response.code}: #{response.body}"
      end
    end
  end
end