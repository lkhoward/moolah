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

  factory :transaction do
    from_email      { User.find(rand(1..10)).email }
    to_email        { User.find(rand(1..10)).email }
    amount          { Faker::Commerce.price(5.0..80.0) }
  end
end