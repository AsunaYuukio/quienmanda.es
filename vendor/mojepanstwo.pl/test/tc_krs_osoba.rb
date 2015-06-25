require_relative '../krs_osoba.rb'

require 'test/unit'
require 'webmock/test_unit'

class TestKrsOsoba < Test::Unit::TestCase
  def test_get_person
    krs_osoba_stub
    person = Mojepanstwo_pl::KrsOsoba::get 1, ['organizacje']
    assert_equal "Prezes Zarządu", person['object']['layers']['organizacje'].first['role'].first['label']
  end

  def test_get_layer
    krs_osoba_stub
    layer = Mojepanstwo_pl::KrsOsoba::get_layer 1, 'organizacje'
    assert_equal "MARPOL", layer.first['nazwa']
  end

  private

  def krs_osoba_stub
    stub_request(:get, "http://api.mojepanstwo.pl/krs/osoby/1?layers[]=organizacje").
      to_return(body: File.read("dataobject_krs_osoba.stub.json"), status: 200)
  end
end
