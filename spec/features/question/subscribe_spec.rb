require 'rails_helper'

feature 'User can subscribe or unsubscribe question', %q{
  In order to get notifications about new question answers
  As authenticated user
  I'd like to be able to subscribe or unsubscribe question.
}, js: true do
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    let(:user) { create(:user) }

    before do
      sign_in(user)
    end

    scenario 'subscribe' do
      visit question_path(question)

      expect(page).to have_link 'Subscribe'
      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_content 'Subscribed!'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribe' do
      create(:subscription, user: user, question: question)
      visit question_path(question)

      expect(page).to have_link 'Unsubscribe'
      click_on 'Unsubscribe'

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
      expect(page).to have_content 'Unsubscribed!'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'try to subscribe' do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
