require 'rails_helper'

feature 'Authenticate user can delete answer', %q{
  In order for my answer not to be present on the resource,
  I would like to be able to delete answer
} do
  given!(:question) { create(:question, :with_answers) }

  scenario 'Authenticate user is author and trying to delete the question', js: true do
    answer = question.answers.first

    sign_in(answer.author)

    visit question_path(question)

    expect(page).to have_content answer.body

    click_on "Delete answer"

    expect(page).to have_content 'Your answer successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'User is not author and trying to delete the question' do
    user = create(:user)

    answer = question.answers.first

    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answer.body

    expect(page).to_not have_link 'Delete answer'
  end
end
