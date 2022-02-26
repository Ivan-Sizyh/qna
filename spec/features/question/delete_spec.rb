require 'rails_helper'

feature 'Authenticate user can deleate question', %q{
  In order for my question not to be present on the resource,
  I would like to be able to delete question
} do
  given!(:question) { create(:question) }

  scenario 'Authenticate user is author and trying to delete the question' do
    sign_in(question.author)

    visit questions_path

    expect(page).to have_link question.title

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'User is not author and trying to delete the question' do
    user = create(:user)

    sign_in(user)

    visit questions_path

    expect(page).to have_link question.title

    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end