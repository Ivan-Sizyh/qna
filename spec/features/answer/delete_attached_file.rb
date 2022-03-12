require 'rails_helper'

feature 'User can delete answer attached file', %q{
  In order to remove an accidentally attached file
  As an authorized user
  I would like to delete answer attached file
} do
  given!(:answer) { create(:answer, :with_files) }
  given(:file) { answer.files.first }

  describe 'Authenticate user' do
    scenario 'is author delete file', js: true do
      sign_in(answer.author)

      visit question_path(answer.question)

      within "#file-#{file.id}" do
        click_on 'Delete'
      end

      within "#answer-#{answer.id}" do
        expect(page).to_not have_link "#{file.filename}"
      end
    end

    scenario 'not author delete file' do
      user = create(:user)

      sign_in(user)

      visit question_path(answer.question)

      within "#file-#{file.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries delete file' do
    visit question_path(answer.question)

    within "#file-#{file.id}" do
      expect(page).to_not have_link 'Delete'
    end
  end
end
