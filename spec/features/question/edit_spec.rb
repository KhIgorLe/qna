require 'rails_helper'

feature 'user can edit his question', %q{
  In order to edit mistakes
  As an author of questions
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  describe 'question owner' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'tries edit question', js: true do
      within '.questions' do
        fill_in 'Question title', with: 'New title'
        fill_in 'Question body', with: 'New body'
        click_on 'Save question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries edit question with errors', js: true do
      within '.questions' do
        fill_in 'Question title', with: ''
        click_on 'Save question'
      end

      within '.question_errors' do
        expect(page).to have_content "Title can't be blank"
      end
    end
  end

  scenario 'tries edit other user question', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Unauthenticated user tries edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
