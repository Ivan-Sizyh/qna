require 'rails_helper'

feature 'User can comment the answer', %q{
  In order to comment the answer
  As authenticated user
  I'd like to be able to comment the answer on question's page
}, js: true do

  given(:question) { create(:question, :with_answers) }
  given(:answer) { question.answers[1] }

  describe 'Authenticated user comment the answer' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      within "#answer-#{answer.id}" do
        fill_in 'Text', with: 'Text text'

        click_on 'Comment'

        expect(page).to have_content 'Text text'
      end
    end

    context 'multiple sessions', js: true do
      scenario "comment appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within "#answer-#{answer.id}" do
            fill_in 'Text', with: 'Comment text'
            click_on 'Comment'

            expect(page).to have_content 'Comment text'
          end
        end

        Capybara.using_session('guest') do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Comment text'
          end
        end
      end
    end

    scenario 'with invalid data' do
      within "#answer-#{answer.id}" do
        click_on 'Comment'

        expect(page).to have_content "Text can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the answer' do
    visit questions_path(question)

    expect(page).to_not have_link 'Comment'
  end
end
