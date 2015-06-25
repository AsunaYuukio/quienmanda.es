# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quantum, class: MojepanstwoPlKrsOrganization do
    id 1
    nazwa "Quantum"
  end
  
  factory :quantum_with_entity, class: MojepanstwoPlKrsOrganization do
    id 1
    nazwa "Quantum"
    association :entity, factory: :quantum_entity
  end
  
  factory :quantum_entity, class: Entity do
    person false
    name "Quantum"
    published true
    priority '1'
  end
end
