# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person, class: :mojepanstwo_pl_person do
    entity nil
    #association :deputy, factory: :deputy
    #association :krs_person, factory: :krs_person
  end
end
