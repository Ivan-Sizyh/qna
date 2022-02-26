FactoryBot.define do
  sequence :title do |n|
    "Title#{n}"
  end
  factory :question do
    title
    body { "MyText" }
    author { FactoryBot.create(:user) }

    trait :with_answers do
      answers { FactoryBot.create_list(:answer, 3) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
