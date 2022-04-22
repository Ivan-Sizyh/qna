FactoryBot.define do
  factory :comment do
    text { 'New comment' }
    author { FactoryBot.create(:user) }
  end
end
