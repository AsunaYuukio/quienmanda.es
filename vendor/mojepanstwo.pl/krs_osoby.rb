require_relative 'dataset.rb'

module Mojepanstwo_pl class KrsOsoby < Dataset
  def self.search imie_pierwsze, nazwisko
    get_all(
      'krs_osoby', 
      conditions: { 
        'krs_osoby.imie_pierwsze' => imie_pierwsze, 
        'krs_osoby.nazwisko' => nazwisko 
      }
    )
  end
  
  
end end