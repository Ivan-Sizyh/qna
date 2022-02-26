FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end
  factory :answer do
    body
    author { FactoryBot.create(:user) }
    question { FactoryBot.create(:question) }

    trait :invalid do
      body { nil }
    end
  end
end
