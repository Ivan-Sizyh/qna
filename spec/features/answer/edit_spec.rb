require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated can not edit answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user' do
    describe 'User is author' do
      before do
        sign_in(answer.author)
        visit question_path(question)
      end

      scenario 'edits his answer', js: true do
        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors', js: true do
        click_on 'Edit answer'

        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end
    end

    scenario "tries to edit other user's answer", js: true do
      user = create(:user)
      sign_in(user)

      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end
