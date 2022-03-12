include ActionDispatch::TestProcess
FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end
  factory :answer do
    body
    author { FactoryBot.create(:user) }
    question

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")] }
    end
  end
end
