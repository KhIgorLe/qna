require 'rails_helper'

feature 'user can see a list of their badges', %q{
  In order to get list of their badges
  As an authenticated user
  I'd like to be able to view list of my badges
} do

  given(:user) { create(:user) }
  given(:badge) { create(:badge, :attached, user: user) }
  given!(:question) { create(:question, badge: badge) }

  describe 'authenticated user' do
    scenario 'tries view list of his badges' do
      sign_in(user)
      visit questions_path

      click_on 'My badges'

      expect(page).to have_content question.title
      expect(page).to have_css("img[src*='image.jpg']")
      expect(page).to have_content question.badge.name
    end
  end

  scenario 'Unauthenticated user tries view list badges' do
    visit questions_path

    expect(page).to_not have_link 'My badges'
  end
end
