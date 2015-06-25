require '../krs_podmiot.rb'

require 'test/unit'
require 'webmock/test_unit'

class TestKrsPodmiot < Test::Unit::TestCase
  def test_get_podmiot
    krs_podmiot_stub
    podmiot = Mojepanstwo_pl::KrsPodmiot.get 1
    assert_equal 'M.A.D.', podmiot['object']['data']['krs_podmioty.nazwa']
  end
  
  private
  
  def krs_podmiot_stub
    stub_request(:get, "http://api.mojepanstwo.pl/krs/podmioty/1").
      to_return(body: File.read("dataobject_krs_podmiot.stub.json"), status: 200)
  end
end