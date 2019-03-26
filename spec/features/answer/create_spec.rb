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
      fill_in 'Body', with: 'Test answer body'
      click_on 'Give answer'

      within '.answers' do
        expect(page).to have_content 'Test answer body'
      end
    end

    scenario 'give answer for question with errors', js: true do
      click_on 'Give answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'ask question with attached files', js: true do
      fill_in 'Body', with: 'Test answer body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Give answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries tries give answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
  end
end
