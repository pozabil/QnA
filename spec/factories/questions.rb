FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "question's title #{n}" }
    sequence(:body) { |n| "question's body #{n}" }
    best_answer { nil }

    trait :invalid do
      title { nil }
    end

    trait :custom do
      title { "custom question custom title" }
      body { "custom question custom body" }
    end
  end
end
