require 'rails_helper'

feature 'User can view own rewards', %q{
  In order to estimate how useful own answers
  As an authenticate user,
  I would like to look at my rewards
} do

  given(:user) { create(:user) }
  given!(:reward) { create(:reward, user: user) }

  scenario 'Authenticate user see own rewards' do
    sign_in(user)

    click_on 'Your rewards'

    expect(page).to have_content reward.name
  end
end
