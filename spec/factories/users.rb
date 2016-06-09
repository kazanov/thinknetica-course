FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "mail#{n}@sample.com" }
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Time.zone.now
  end
end
