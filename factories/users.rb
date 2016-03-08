require 'faker'

FactoryGirl.define do
  factory :user do
    email     { Faker::Internet.safe_email }
    name      { Faker::Name.name }
    phone     { Faker::PhoneNumber.cell_phone }
    password  { Faker::Internet.password(8, 12, true, true) }
    admin     'N'
  end

  factory :account do
    user_id  1
    balance  { Faker::Commerce.price(100.0..1000.0) }
  end

  factory :activity do
    from_account_id   { rand(1..10) }
    to_account_id     { rand(1..10) }
    transaction_type  { ['C', 'D'].sample }
    amount            { Faker::Commerce.price(5.0..80.0) }
  end
end