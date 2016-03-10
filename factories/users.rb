require 'faker'
require 'chronic'

FactoryGirl.define do
  factory :user do
    name      { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
    email     { "#{name.downcase.gsub(' ', '.')}@#{Faker::Internet.domain_name}" }
    phone     { Faker::PhoneNumber.cell_phone }
    password  { Faker::Internet.password(8, 8, true, false) }
    admin     'N'
    balance   { Faker::Commerce.price(100.0..1000.0) }
  end

  factory :transaction do
    from_email      { User.find(rand(16..30)).email }
    to_email        { User.find(rand(1..15)).email }
    amount          { Faker::Commerce.price(5.0..80.0) }
    created_at      { Chronic.parse("#{rand(0..500)} days ago") }
    updated_at      { created_at }
  end
end