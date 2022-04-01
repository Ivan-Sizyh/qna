require 'rails_helper'

feature 'The user can vote for the question', %q{
  In order to show that you are interested in this question
  As an authorized user
  I would like to vote the question
}, js: true do
  given(:question) { create(:question) }

  describe 'Authenticate user' do
    context 'Not question author' do
      let(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'up question' do
        within ".question" do
          within '.question-voting' do
            expect(page).to have_link 'UP'

            click_on 'UP'

            expect(page).to have_content 'Score: 1'
          end
        end
      end

      scenario 'down question' do
        within ".question" do
          within '.question-voting' do
            expect(page).to have_link 'DOWN'

            click_on 'DOWN'

            expect(page).to have_content 'Score: -1'
          end
        end
      end

      context 'User has already voted' do
        background do
          expect(page).to have_link 'DOWN'
          click_on 'DOWN'
          visit question_path(question)
        end

        scenario 'tires to vote question twice' do
          within ".question" do
            within '.question-voting' do
              expect(page).to_not have_link 'UP'
              expect(page).to_not have_link 'DOWN'

              expect(page).to have_content 'Score: -1'
            end
          end
        end

        scenario 'tires to cancel question vote' do
          within ".question" do
            within '.question-voting' do
              expect(page).to have_link 'Cancel'

              click_on 'Cancel'

              expect(page).to have_content 'Score: 0'
              expect(page).to have_link 'UP'
              expect(page).to have_link 'DOWN'
            end
          end
        end
      end
    end

    context 'Question author' do
      background do
        sign_in(question.author)
        visit question_path(question)
      end

      scenario 'tries to vote question' do
        within ".question" do
          within '.question-voting' do
            expect(page).to_not have_link 'UP'
            expect(page).to_not have_link 'DOWN'
            expect(page).to_not have_link 'Cancel'
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to vote question' do
      visit question_path(question)

      within ".question" do
        within '.question-voting' do
          expect(page).to_not have_link 'UP'
          expect(page).to_not have_link 'DOWN'
          expect(page).to_not have_link 'Cancel'
        end
      end
    end
  end
end
