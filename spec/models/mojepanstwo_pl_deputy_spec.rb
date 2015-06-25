require 'spec_helper'

describe MojepanstwoPlDeputy do

  let! :dataset_poslowie_mock do
    [1,2].each do |page|
      stub_request(:get, "api.mojepanstwo.pl/dane/dataset/poslowie/search.json?page=#{page}").
        to_return(body: File.read("#{Rails.root}/spec/models/dataset_poslowie_page#{page}.stub.json"), status: 200)
    end
  end

  context "on create" do
    context "if there is no matching person" do
      it "should create person" do
        deputy = create :deputy
        expect(deputy.person).not_to be_nil
      end
    end
    context "if there is matching person" do
      it "should connect with this person" do
        krs_person = create :krs_person
        deputy = create :deputy, krs_osoba_id: 1
        expect(deputy.person.krs_person).to eq krs_person
      end
    end
  end

  context "geting all deputies from mojepanstwo.pl via dataset" do
    it "should get all the deputies and store them" do
      deputies = MojepanstwoPlDeputy::import_all
      expect(MojepanstwoPlDeputy.find(3).get_name).to eq "Andrzej Mieczysław Adamczyk"
    end
  end

  context "build_krs_person" do
    it "should build krs person" do
      deputy = create :deputy, krs_osoba_id: 1
      deputy.build_krs_person
      deputy.save!
      expect(deputy.person.krs_person).to_not be_nil
    end
  end

  context "updateing entity" do
    #update_entity
  end
end
