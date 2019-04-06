require 'rails_helper'

feature 'User can vote for the question he likes', %q{
  In order to to increase the question rating
  As an authenticated user
  I'd like to be able to up rating for question
} do

  given(:owner) { create(:user) }
  given(:not_owner) { create(:user) }
  given(:question) { create(:question, user: owner) }

  describe 'not owner question' do
    background do
      sign_in(not_owner)
      visit question_path(question)
    end

    scenario 'change rating by 1, only once', js: true do
      click_on '+'

      within '.question' do
        expect(page).to have_content 'Question rating: 1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'change rating by -1, only once', js: true do
      click_on '-'

      within '.question' do
        expect(page).to have_content 'Question rating: -1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'cancel rating', js: true do
      click_on '+'

      within '.question' do
        expect(page).to have_link 'Cancel vote'
      end
    end
  end

  describe 'owner question' do
    background do
      sign_in(owner)
      visit question_path(question)
    end

    scenario 'can not change rating' do
      expect(page).to_not have_link '+'
      expect(page).to_not have_link '-'
    end
  end
end

