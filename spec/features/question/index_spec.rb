require 'rails_helper'

feature 'User can view all questions', %q{
  In order to find the question
  I am interested in,
  I would like to look through all the existing questions
} do
  scenario 'Any user can view questions' do
    questions = create_list(:question, 2)

    visit questions_path

    questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
  end
end