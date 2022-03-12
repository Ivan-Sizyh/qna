require 'rails_helper'

feature 'User can delete question attached file', %q{
  In order to remove an accidentally attached file
  As an authorized user
  I would like to delete question attached file
} do
  given!(:question) { create(:question, :with_files) }
  given(:file) { question.files.first }

  describe 'Authenticate user' do
    scenario 'is author delete file', js: true do
      sign_in(question.author)

      visit question_path(question)

      within "#file-#{file.id}" do
        click_on 'Delete'
      end

      within ".question" do
        expect(page).to_not have_link "#{file.filename}"
      end
    end

    scenario 'not author delete file' do
      user = create(:user)

      sign_in(user)

      visit question_path(question)

      within "#file-#{file.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries delete file' do
    visit question_path(question)

    within "#file-#{file.id}" do
      expect(page).to_not have_link 'Delete'
    end
  end
end
