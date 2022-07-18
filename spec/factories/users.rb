FactoryBot.define do
  factory :user do
    email { 'test@user.test' }
    password { 'correct_password1'}

    trait :wrong do
      password { 'wrong_password2'}
    end
  end
end
