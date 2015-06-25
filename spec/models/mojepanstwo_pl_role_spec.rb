require 'spec_helper'

describe MojepanstwoPlRole do
  context "setup_relation" do
    context "without relation" do
      it "should create relation" do
        role = create :role
        role.setup_relation
        relation = Relation.where(
          source_id: role.krs_person.person.entity.id, 
          target_id: role.krs_organization.entity.id,
          relation_type: RelationType.find_by(description: role.function)
        )
        expect(relation).to exist
      end
    end
    
    # TODO: write test on update relation
#    context "with relation" do
#      it "should update relation" do
#        role = create :role, function: 'Sidekick'
#        role.setup_relation
#        expect(role.reload.relation.relation_type.description).to eq 'Sidekick'
#      end
#    end
  end
end
