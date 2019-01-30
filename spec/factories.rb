require 'faker'

FactoryBot.define do

  factory :user do
    first_name { "Joe" }
    last_name { "Smith" }
    email { Faker::Internet.email }
    password { "123456" }
  end

end