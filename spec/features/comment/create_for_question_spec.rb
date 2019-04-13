require 'rails_helper'

feature 'User can create comments for question', %q{
  In order to create comments to question
  As an authenticated user
  I'd like to be able to set comments for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give comment for question', js: true do
      within '.question' do
        click_on 'Add comment'
        fill_in 'Comment body', with: 'it comment'
        click_on 'Save comment'

        expect(page).to_not have_selector "#Add-Question-Comment-#{question.id}"
      end

      within '.question-comments' do
        expect(page).to have_content 'it comment'
      end
    end

    context 'multiple session' do
      scenario 'comment appears on another user page', js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('quest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within '.question' do
            click_on 'Add comment'
            fill_in 'Comment body', with: 'it comment'
            click_on 'Save comment'

            expect(page).to_not have_selector "#Add-Question-Comment-#{question.id}"
          end

          within '.question-comments' do
            expect(page).to have_content 'it comment'
          end
        end

        Capybara.using_session('quest') do
          within '.question-comments' do
            expect(page).to have_content 'it comment'
          end
        end
      end
    end

    scenario 'give comment with error', js: true do
      within '.question' do
        click_on 'Add comment'
        click_on 'Save comment'
      end

      within '.comment_errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries set comment' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Add comment'
    end
  end
end
