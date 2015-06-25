require 'spec_helper'

describe MojepanstwoPlPerson do
  context "person with deputy without entity" do
    it "should create entity on setup_entity and assign entity" do
      deputy = create :deputy
      person = deputy.person
      person.setup_entity
      entity = Entity.find_by name: 'Lena Doe'
      expect(entity.description).to eq "Poseł."
      expect(person.reload.entity).to eq entity
    end
  end

  context "person with krs_person and deputy and with entity" do
    it "should update entity on setup_entity" do
      deputy = create :deputy
      person = deputy.person
      entity = create :public_person, name: 'Elena'
      person.entity = entity
      person.setup_entity
      entity = Entity.find_by name: 'Lena Doe'
      expect(entity.description).to eq "Poseł."
    end
  end

  context "two person with deputiy with same name" do
    it "should create entity with '(2)' sufix for the second one" do
      deputy = create :deputy
      create :public_person, name: "Lena Doe"
      deputy.person.setup_entity
      expect(deputy.person.entity.name).to eq "Lena Doe (2)"
    end
  end

  context "two person with deputiy with same name" do
    it "should set name for entity with '(2)' sufix for the second one" do
      create :public_person, name: "Lena Doe"
      deputy = create :deputy
      deputy.person.setup_entity
      deputy.person.setup_entity
      expect(deputy.person.entity.name).to eq "Lena Doe (2)"
    end
  end
end
