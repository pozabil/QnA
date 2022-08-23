FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test@user#{n}.test" }
    password { "password1" }
    password_confirmation { "password1" }
  end
end
