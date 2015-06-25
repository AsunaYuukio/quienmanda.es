require_relative '../poslowie.rb'

require 'test/unit'
require 'webmock/test_unit'

class TestPoslowie < Test::Unit::TestCase

  def test_get_poslowie
    dataset_poslowie_stub
    poslowie = Mojepanstwo_pl::Poslowie.get
    assert_equal 21, poslowie.size
    assert_equal "Andrzej", poslowie.last['data']['poslowie.imie_pierwsze']
  end

  private

  def dataset_poslowie_stub
    [1,2].each do |page|
      stub_request(:get, "api.mojepanstwo.pl/dane/dataset/poslowie/search.json?page=#{page}").
        to_return(body: File.read("dataset_poslowie_page#{page}.stub.json"), status: 200)
    end
  end

end
