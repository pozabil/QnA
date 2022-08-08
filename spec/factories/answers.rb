FactoryBot.define do
  sequence :body do |n|
    "answer's body #{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end

    trait :custom do
      body { "custom answer custom body" }
    end
  end
end
