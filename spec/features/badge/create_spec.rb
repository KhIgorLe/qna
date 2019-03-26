require 'rails_helper'

feature 'User can create badge', %q{
  In order to set badge to question
  As an question owner
  I'd like to be able to set badge for question
} do

  given(:user) { create(:user) }

  describe 'question owner' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Question title', with: 'Test question'
      fill_in 'Question body', with: 'text text text'
    end

    scenario 'ask question with badge' do
      fill_in 'Badge name', with: 'Test badge'
      attach_file 'Badge image', "#{Rails.root}/spec/fixtures/files/image.jpg"

      click_on 'Save question'

      within '.question .badge' do
       expect(page).to have_css("img[src*='image.jpg']")
      end
    end

    scenario 'ask question with badge with errors' do
      attach_file 'Badge image', "#{Rails.root}/spec/fixtures/files/image.jpg"

      click_on 'Save question'

      expect(page).to have_content "Badge name can't be blank"
    end
  end
end

