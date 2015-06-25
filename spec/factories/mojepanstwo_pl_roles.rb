# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role, class: MojepanstwoPlRole do
    association :krs_person,       factory: :krs_person_with_entity
    association :krs_organization, factory: :quantum_with_entity
    function "Boss"
    canceled false
  end
end
