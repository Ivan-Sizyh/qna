require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:question) { create(:question) }

  scenario 'Unauthenticated can not edit question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    describe 'User is author' do
      background do
        sign_in(question.author)
        visit question_path(question)
      end

      scenario 'edits his answer', js: true do
        within '.question' do
          click_on 'Edit question'
          fill_in 'Title', with: 'edited question title'
          fill_in 'Body', with: 'edited question body'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question title'
          expect(page).to have_content 'edited question body'
          expect(page).to_not have_selector 'input'
          expect(page).to_not have_selector 'textarea'
        end
        expect(page).to have_content 'Your question has been successfully updated!'
      end

      scenario 'edits his answer with errors', js: true do
        within '.question' do
          click_on 'Edit question'
          fill_in 'Title', with: ''
          fill_in 'Body', with: ''
          click_on 'Save'

          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"

          expect(page).to have_selector 'input'
          expect(page).to have_selector 'textarea'
        end
        expect(page).to_not have_content 'Your question has been successfully updated!'
      end
    end

    scenario "tries to edit other user's answer" do
      user = create(:user)
      sign_in(user)

      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
