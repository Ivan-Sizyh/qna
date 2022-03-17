FactoryBot.define do
  factory :reward do
    name { "MyString" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/reward.jpeg") }
    question
  end
end
