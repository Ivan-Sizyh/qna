require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    page.first('.sign_up_button').click

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with unmatched passwords' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '1234567'
    page.first('.sign_up_button').click

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Unregistered user tries to sign up with errors' do
    page.first('.sign_up_button').click

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Registered user tries to sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    page.first('.sign_up_button').click

    expect(page).to have_content "Email has already been taken"
  end
end
