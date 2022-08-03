FactoryBot.define do
  sequence :title do |n|
    "question's title #{n}"
  end

  factory :question do
    title
    body { "body" }

    trait :invalid do
      title { nil }
    end
  end
end
