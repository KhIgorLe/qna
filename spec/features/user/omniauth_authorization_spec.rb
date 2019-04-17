require 'rails_helper'

feature 'User can sign in with provider account',%q{
  In order to sign in with provider account
  As an  user
  I'd like to be able to sign in using provider account
} do

  given(:user) { create(:user) }

  %w[GitHub Facebook].each do |provider|

    scenario "User can sign using #{provider} account" do
      visit new_user_session_path

      mock_auth_hash(provider)

      click_on "Sign in with #{provider}"

      expect(page).to have_content "Successfully authenticated from #{provider.humanize} account."
      expect(page).to have_link 'Log out'
    end

    scenario "User can not sign using #{provider} with invalid data" do
      visit new_user_session_path

      invalid_mock_auth_hash(provider)

      click_on "Sign in with #{provider}"

      expect(page).to have_content "Could not authenticate you from #{provider} because \"Invalid credentials\"."
      expect(page).to_not have_link 'Log out'
    end
  end
end
