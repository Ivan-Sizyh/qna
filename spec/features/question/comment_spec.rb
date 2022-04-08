require 'rails_helper'

feature 'User can comment the question', %q{
  In order to comment the question
  As authenticated user
  I'd like to be able to comment the question
}, js: true do

  given(:question) { create(:question) }

  describe 'Authenticated user comment the question' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      within "#question-#{question.id}" do
        fill_in 'Text', with: 'Text text'

        click_on 'Comment'

        expect(page).to have_content 'Text text'
      end
    end

    context 'multiple sessions' do
      scenario "comment appears on another user's page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within "#question-#{question.id}" do
            fill_in 'Text', with: 'Comment text'
            click_on 'Comment'

            expect(page).to have_content 'Comment text'
          end
        end

        Capybara.using_session('guest') do
          within "#question-#{question.id}" do
            expect(page).to have_content 'Comment text'
          end
        end
      end
    end

    scenario 'with invalid data' do
      within "#question-#{question.id}" do
        click_on 'Comment'

        expect(page).to have_content "Text can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the question' do
    visit questions_path(question)

    expect(page).to_not have_link 'Comment'
  end
end
