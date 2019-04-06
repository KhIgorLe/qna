require 'rails_helper'

feature 'User can vote for the answer he likes', %q{
  In order to to increase the answer rating
  As an authenticated user
  I'd like to be able to up rating for answe
} do

  given(:owner) { create(:user) }
  given(:not_owner) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: owner)}

  describe 'not owner answer' do
    background do
      sign_in(not_owner)
      visit question_path(question)
    end

    scenario 'change rating by 1, only once', js: true do
      within '.answers' do
        click_on '+'
      end

      within '.answers' do
        expect(page).to have_content 'Answer rating: 1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'change rating by -1, only once', js: true do
      within '.answers' do
        click_on '-'
      end

      within '.answers' do
        expect(page).to have_content 'Answer rating: -1'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'cancel rating', js: true do
      within '.answers' do
        click_on '+'
      end

      within '.answers' do
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
      within '.answers' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end
  end
end
