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

    scenario 'Authenticate user create answer' do
      fill_in 'Body', with: 'text text text'
      click_on 'Create Answer'

      expect(page).to have_content 'Your answer has been successfully created!'
      expect(page).to have_content 'text text text'
    end

    scenario 'Authenticate user create answer with errors' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user create answer' do
    visit question_path(question)

    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end