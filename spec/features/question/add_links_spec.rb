require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) {'https://google.ru'}

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
  end

  scenario 'User adds link when asks question' do
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: url
  end

  scenario 'User adds link with errors when asks question' do
    fill_in 'Url', with: 'invalid url'

    click_on 'Ask'

    expect(page).to have_content 'Links url is not a valid URL'
  end
end