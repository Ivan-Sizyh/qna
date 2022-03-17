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
      given!(:link) { create(:link, name: 'youtube', url: 'https://www.youtube.com', linkable: answer) }
      given(:google_url) { 'https://www.google.ru/' }

      before do
        sign_in(answer.author)
        visit question_path(question)

        click_on 'Edit answer'
      end

      describe 'with valid data' do
        before do
          within '.answers' do
            fill_in 'Your answer', with: 'edited answer'
          end
        end

        scenario 'edits his answer with attach files', js: true do
          within '.answers' do
            attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
            expect(page).to have_link 'rails_helper.rb'
            expect(page).to have_link 'spec_helper.rb'
          end
        end

        scenario 'edits his answer', js: true do
          within '.answers' do
            click_on 'Save'

            expect(page).to_not have_content answer.body
            expect(page).to have_content 'edited answer'
            expect(page).to_not have_selector 'textarea'
          end
        end

        scenario 'edits his question with links', js: true do
          within '.answers' do
            fill_in 'Link name', with: 'edited link name'
            fill_in 'Url', with: google_url

            click_on 'Save'

            expect(page).to have_link 'edited link name', href: google_url
          end
        end
      end

      scenario 'edits his answer with errors', js: true do
        within '.answers' do
          fill_in 'Your answer', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end

      scenario 'edits his question with not valid links', js: true do
        within '.answers' do
          fill_in 'Link name', with: 'edited link name'
          fill_in 'Url', with: 'not valid link'

          click_on 'Save'

          expect(page).to_not have_link 'edited link name'
          expect(page).to have_content 'Links url is not a valid URL'
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
