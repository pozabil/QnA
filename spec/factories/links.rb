FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "google link #{n}" }
    sequence(:url) { |n| "www.google.com/#{n}" }

    trait :correct do
      name { 'google' }
      url { 'google.com' }
    end

    trait :another_correct do
      name { 'thinknetica' }
      url { 'https://thinknetica.com' }
    end

    trait :wrong do
      name { 'wrong link' }
      url { 'wrong_link' }
    end
  end
end
