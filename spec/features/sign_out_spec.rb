require 'rails_helper'

feature 'User can sign out', %q{
  In order to sign in from another account
  As authenticate user
  I would like to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authenticate user tries sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries sign out' do
    expect(page).to_not have_link 'Sign out'
  end
end