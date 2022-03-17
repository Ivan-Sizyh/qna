require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://google.ru' }

  background do
    sign_in(user)
    visit question_path(question)

    within '.create-answer' do
      fill_in 'Body', with: 'My answer'

      fill_in 'Link name', with: 'My link'
    end
  end

  scenario 'User adds link when give an answer', js: true do
    within '.create-answer' do
      fill_in 'Url', with: url

      click_on 'Create Answer'
    end

    expect(page).to have_link 'My link', href: url
  end

  scenario 'User adds link with errors when give an answer', js: true do
    within '.create-answer' do
      fill_in 'Url', with: 'invalid url'

      click_on 'Create Answer'
    end

    expect(page).to have_content 'Links url is not a valid URL'
  end
end