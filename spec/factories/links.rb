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

    trait :gist_plain_text do
      name { 'gist_plain_text' }
      url { 'https://gist.github.com/pozabil/65bf63f8c050f0b576f60f5fddbb2208' }
    end

    trait :gist_html_js_code do
      name { 'gist_html_js_code' }
      url { 'https://gist.github.com/pozabil/3a6c82e39e1960fb37a47502c27c4782' }
    end

    trait :gist_multiple_files do
      name { 'gist_multiple_files' }
      url { 'https://gist.github.com/pozabil/6ef53ccf83ad43478b46c6bd7e669ce7' }
    end

    trait :wrong_gist do
      name { 'wrong_gist' }
      url { 'https://gist.github.com/pozabil/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' }
    end
  end
end
