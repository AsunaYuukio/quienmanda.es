require 'spec_helper'

describe MojepanstwoPlKrsOrganization do
  
  let! :dataobject_krs_podmiot_mock do
    stub_request(:get, "http://api.mojepanstwo.pl/krs/podmioty/1").
      to_return(body: File.read("#{Rails.root}/spec/models/dataobject_krs_podmiot.stub.json"), status: 200)
  end
  
  context "By given id" do
    it "should get data and store it" do
      organization = MojepanstwoPlKrsOrganization.import 1
      expect(organization.nazwa).to eq "M.A.D."
    end
  end
  
  context "On object import" do
    it "should update data" do
      organization = create :quantum
      org = organization.import
      expect(org.nazwa).to eq "M.A.D."
    end
  end
  
  context "On setup_entity" do
    context "for the first time" do
      it "should create entity" do
        organization = create :quantum
        organization.setup_entity
        entity = Entity.find_by name: "Quantum";
        expect(entity.person).to eq false
      end
    end
    
    context "for the second time" do
      it "should update entity" do
        entity = create :quantum_entity
        organization = create :quantum, entity: entity, nazwa: "M.A.D."
        organization.setup_entity
        expect(entity.reload.name).to eq "M.A.D."
      end
    end
  end
end
