# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mojepanstwo_pl_public_order do
    id 1
    slug "MyString"
    price "MyString"
    status 1
    contractor_id 1
    procurer_id 1
    order_number 1
  end
end
