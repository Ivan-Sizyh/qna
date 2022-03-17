require 'rails_helper'

feature 'User can add rewards to question', %q{
  In order to award user for the answer
  As an question's author
  I'd like to be able to add reward
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Reward', with: 'New rewards'
  end

  scenario 'User adds reward when asks question' do
    attach_file 'Image', "#{Rails.root}/app/assets/images/reward.jpeg"

    click_on 'Ask'

    within '.reward' do
      expect(page).to have_content 'New rewards'
      expect(page).to have_css('img')
    end
  end

  scenario 'User adds reward with errors' do
    click_on 'Ask'

    expect(page).to have_content "Reward image can't be blank"
  end
end
