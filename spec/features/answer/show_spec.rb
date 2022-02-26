require 'rails_helper'

feature 'The user can view the question and the answers to it', %q{
  In order to find the answer to my question,
  I would like to view the question
  and all the answers to it
} do
  scenario 'Any user can view questions and all the answers to it' do
    question = create(:question, :with_answers)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end
