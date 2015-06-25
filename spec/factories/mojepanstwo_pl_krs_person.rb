FactoryGirl.define do
  factory :krs_person, class: :mojepanstwo_pl_krs_person do
    id 1
    imie_pierwsze "Lena"
    nazwisko "Smith"
  end

  factory :krs_person_with_entity, class: :mojepanstwo_pl_krs_person do
    id 1
    imie_pierwsze "Lena"
    nazwisko "Smith"
    association :person, factory: :person_with_entity
  end

  factory :person_with_entity, class: :mojepanstwo_pl_person do
    krs_person_id 1
    association :entity, factory: :person_entity
  end

  factory :person_entity, class: :entity do
    person true
    name "Lena Smith"
    published true
    priority '1'
  end
end
