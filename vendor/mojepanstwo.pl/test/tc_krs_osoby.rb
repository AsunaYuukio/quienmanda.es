require_relative '../krs_osoby.rb'

require 'test/unit'
require 'webmock/test_unit'

class TestKrsOsoby < Test::Unit::TestCase
  def test_search
    search_krs_osoba_stub
    people = Mojepanstwo_pl::KrsOsoby.search "Agnieszka", "Abakumow"
    assert_equal "Agnieszka", people.first["data"]["krs_osoby.imie_pierwsze"]
  end
  
  def test_nothing_found
    search_krs_osoba_stub
    people = Mojepanstwo_pl::KrsOsoby.search "Marlena", "Wytrych"
    assert_equal [], people
  end
  
  private
  
  def search_krs_osoba_stub
    url = "http://api.mojepanstwo.pl/dane/dataset/krs_osoby/search.json?conditions[krs_osoby.imie_pierwsze]=Agnieszka&conditions[krs_osoby.nazwisko]=Abakumow&page=1"
    stub_request(:get, url).
      to_return(body: File.read("search_krs_osoby_agnieszka_abakumow.stub.json"), status: 200)
    
    url = "http://api.mojepanstwo.pl/dane/dataset/krs_osoby/search.json?conditions[krs_osoby.imie_pierwsze]=Marlena&conditions[krs_osoby.nazwisko]=Wytrych&page=1"
    stub_request(:get, url).
      to_return(body: File.read("search_krs_osoby_marlena_wytrych.stub.json"), status: 200)
  end
end