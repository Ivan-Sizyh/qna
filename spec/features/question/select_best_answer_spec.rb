require 'rails_helper'

feature 'User can select best answer', %q{
  In order to show the most effective solution
  As an author of question
  I'd like ot be able to select best answer
} do

  given!(:question) { create(:question, :with_answers) }

  scenario 'Unauthenticated can not select best answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Select best'
  end

  describe 'Authenticated user' do
    describe 'User is author' do
      background do
        sign_in(question.author)
        visit question_path(question)
      end

      scenario 'author select best answer', js: true do
        answer = question.answers.first
        within "#answer-#{answer.id}" do
          click_on 'Select best'
        end

        expect(page).to have_selector '.best-answer'

        within '.best-answer' do
          expect(page).to have_content answer.body
        end
      end

      scenario 'author select another best answer', js: true do
        answer1 = question.answers.first
        answer2 = question.answers.last
        within "#answer-#{answer1.id}" do
          click_on 'Select best'
        end

        expect(page).to have_selector '.best-answer'

        within '.best-answer' do
          expect(page).to have_content answer1.body
        end

        within "#answer-#{answer2.id}" do
          click_on 'Select best'
        end

        within '.best-answer' do
          expect(page).to have_content answer2.body
        end
      end
    end

    scenario "tries to select best answer other user's question", js: true do
      user = create(:user)

      sign_in(user)

      visit question_path(question)

      expect(page).to_not have_link 'Select best'
    end
  end
end
