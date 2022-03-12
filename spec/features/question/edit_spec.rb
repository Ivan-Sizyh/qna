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

        click_on 'Edit question'
      end

      describe 'with valid data' do
        background do
          within '.question' do
            fill_in 'Title', with: 'edited question title'
            fill_in 'Body', with: 'edited question body'
          end
        end

        scenario 'edits his question', js: true do
          within '.question' do
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

        scenario 'edits his question with attach files', js: true do
          within '.question' do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

            click_on 'Save'

            expect(page).to_not have_content question.title
            expect(page).to_not have_content question.body
            expect(page).to have_content 'edited question title'
            expect(page).to have_content 'edited question body'
            expect(page).to_not have_selector 'input'
            expect(page).to_not have_selector 'textarea'
            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end
      end

      scenario 'edits his question with errors', js: true do
        within '.question' do
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

    scenario "tries to edit other user's question" do
      user = create(:user)
      sign_in(user)

      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
