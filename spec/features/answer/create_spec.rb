require 'rails_helper'

feature 'User can create answer on question page', %q{
  In order to answer another user's question
  As an authorized user
  I would like to create an answer on question page
} do
  given(:question) { create(:question) }

  describe  'Authenticate user' do
    given(:user) { create(:user) }

    background do
      sign_in(user)

      visit question_path(question)
    end

    describe 'With correct data' do
      background { fill_in 'Body', with: 'text text text' }

      scenario 'user create answer', js: true do
        click_on 'Create Answer'

        expect(page).to have_content 'Your answer has been successfully created!'
        expect(page).to have_content 'text text text'
      end

      scenario 'user create answer with attached files', js: true do
        within '.new-answer' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Create Answer'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Authenticate user create answer with errors', js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user create answer', js: true do
    visit question_path(question)

    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
