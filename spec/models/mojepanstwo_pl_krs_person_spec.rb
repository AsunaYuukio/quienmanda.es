require 'spec_helper'

describe MojepanstwoPlKrsPerson do

  let! :dataobject_krs_osoba_mock do
    stub_request(:get, "http://api.mojepanstwo.pl/krs/osoby/1").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_osoba.stub.json"), status: 200)

  stub_request(:get, "http://api.mojepanstwo.pl/krs/osoby/2").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_osoba2.stub.json"), status: 200)

    stub_request(:get, "http://api.mojepanstwo.pl/krs/osoby/1?layers[]=organizacje").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_osoba.stub.json"), status: 200)

    stub_request(:get, "http://api.mojepanstwo.pl/krs/podmioty/1").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_podmiot.stub.json"), status: 200)

    stub_request(:get, "http://api.mojepanstwo.pl/krs/podmioty/2").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_podmiot2.stub.json"), status: 200)

    url = "http://api.mojepanstwo.pl/dane/dataset/krs_osoby/search.json?conditions[krs_osoby.imie_pierwsze]=Agnieszka&conditions[krs_osoby.nazwisko]=Abakumow&page=1"
    stub_request(:get, url).
      to_return(body: File.read("#{Rails.root}/spec/models/search_krs_osoby_agnieszka_abakumow.stub.json"), status: 200)
  end

  context "creating krs_person" do
    context "if there is no matching person" do
      it "should create person" do
        krs_person = create :krs_person
        expect(krs_person.person).to_not be_nil
      end
    end
    context "if there is maching person" do
      it "should assign this person" do
        deputy = create :deputy, krs_osoba_id: 1
        krs_person = create :krs_person
        expect(krs_person.person.deputy).to eq deputy
      end
    end
  end

  context "import not existing krs person" do
    it "should get person data and create record" do
      krs_person = MojepanstwoPlKrsPerson.import 1
      expect(MojepanstwoPlKrsPerson.find(1).imie_pierwsze).to eq "Agnieszka"
    end
  end

  context "import existing krs person" do
    it "should update information about this person" do
      krs_person = create :krs_person
      krs_person.import
      expect(krs_person.reload.imie_pierwsze).to eq "Agnieszka"
    end
  end

  context "import person whose isn't in database" do
    it "should return nil" do
      krs_person = create :krs_person, id: 2
      expect(krs_person.import).to be_nil
    end
  end

#  context "get_roles" do
#    it "should get user's roles (but not store them!)" do
#      krs_person = create :krs_person
#      krs_person.get_roles
#      mad = krs_person.roles.find{|role| role.krs_organization.nazwa == "M.A.D."}
#      expect(mad).not_to be_nil
#      expect(mad.id).to be_nil
#      quantum = krs_person.roles.find{|role| role.krs_organization.nazwa == "Quantum"}
#      expect(quantum).not_to be_nil
#      expect(quantum.id).to be_nil
#    end
#  end

  context "import_roles" do
    it "should get user's roles and store them also it should import necessary organizations" do
      krs_person = create :krs_person
      krs_person.import_roles
      krs_person.reload
      mad = krs_person.krs_organizations.find{|org| org.nazwa == "M.A.D."}
      expect(mad).not_to be_nil
      quantum = krs_person.krs_organizations.find{|org| org.nazwa == "Quantum"}
      expect(quantum).not_to be_nil
    end
  end

  context "get organizations" do
    it "should get user's organizations id (from roles)" do
      krs_person = create :krs_person
      org_ids = krs_person.get_organizations_id
      expect(org_ids).to include "1"
      expect(org_ids).to include "2"
    end
  end

  context "search_krs" do
    it "should return array of people found in krs database" do
      people = MojepanstwoPlKrsPerson.search_krs "Agnieszka", "Abakumow"
      expect(people.first.get_name).to eq "Agnieszka Abakumow"
    end
  end
end
