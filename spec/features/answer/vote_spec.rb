require 'rails_helper'

feature 'The user can vote for the answer', %q{
  In order to show that the answer helped
  As an authorized user
  I would like to vote the answer
}, js:true do
  given(:answer) { create(:answer) }

  describe 'Authenticate user' do
    context 'Not answer author' do
      let(:user) { create(:user) }

      background do
        sign_in(user)
        visit question_path(answer.question)
      end

      scenario 'up answer' do
        within "#answer-#{answer.id}" do
          within '.answer-voting' do
            expect(page).to have_link 'UP'

            click_on 'UP'

            expect(page).to have_content 'Score: 1'
          end
        end
      end

      scenario 'down answer' do
        within "#answer-#{answer.id}" do
          within '.answer-voting' do
            expect(page).to have_link 'DOWN'

            click_on 'DOWN'

            expect(page).to have_content 'Score: -1'
          end
        end
      end

      context 'User has already voted' do
        background do
          within "#answer-#{answer.id}" do
            expect(page).to have_link 'DOWN'
            click_on 'DOWN'
          end
          visit question_path(answer.question)
        end

        scenario 'tires to vote answer twice' do
          within "#answer-#{answer.id}" do
            within '.answer-voting' do
              expect(page).to_not have_link 'UP'
              expect(page).to_not have_link 'DOWN'

              expect(page).to have_content 'Score: -1'
            end
          end
        end

        scenario 'tires to cancel answer vote' do
          within "#answer-#{answer.id}" do
            within '.answer-voting' do
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

    context 'Answer author' do
      background do
        sign_in(answer.author)
        visit question_path(answer.question)
      end

      scenario 'tries to vote answer' do
        within "#answer-#{answer.id}" do
          within '.answer-voting' do
            expect(page).to_not have_link 'UP'
            expect(page).to_not have_link 'DOWN'
            expect(page).to_not have_link 'Cancel'
          end
        end
      end
    end
  end
end
