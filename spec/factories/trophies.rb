FactoryBot.define do
  factory :trophy do
    sequence(:title) { |n| "best_answer_trophy's title #{n}" }
    image { {io: File.open("#{Rails.root}/spec/file_fixtures/pes_s_rukoi.jpg"), filename: 'pes_s_rukoi.jpg'} }
  end
end
