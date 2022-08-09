FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "answer's body #{n}" }

    trait :invalid do
      body { nil }
    end

    trait :custom do
      body { "custom answer custom body" }
    end
  end
end
