FactoryBot.define do
  sequence :email do |n|
    "test@user#{n}.test"
  end

  factory :user do
    email
    password { "password1" }
    password_confirmation { "password1" }
  end
end
