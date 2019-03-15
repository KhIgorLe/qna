require 'rails_helper'

feature 'User can give answers for questions', %q{
  In order to give an answer to the community
  As an authenticated user
  I'd like to be able to give the answer for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give answer for question', js: true do
      fill_in 'Body', with: 'Test question body'
      click_on 'Give answer'

      within '.answers' do
        expect(page).to have_content 'Test question body'
      end
    end

    scenario 'give answer for question with errors', js: true do
      click_on 'Give answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries tries give answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
  end
end
