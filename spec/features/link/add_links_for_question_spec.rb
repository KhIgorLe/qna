require 'rails_helper'

feature 'User can add links for question', %q{
  In order to provide additional info to my question
  As an questions author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/KhIgorLe/2bfafe90ab91aa1f4b468e9746f613a0' }
  given(:url) { 'https://google.com' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Question title', with: 'Test question'
      fill_in 'Question body', with: 'text text text'

      within '.links' do
        click_on 'add link'
      end
    end

    scenario 'can adds links', js: true do

      within(all('.nested-fields')[0]) do
        fill_in 'Link name', with: 'My google'
        fill_in 'Url', with: url
      end

      within '.links' do
        click_on 'add link'
      end

      within(all('.nested-fields')[1]) do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Save question'

      within '.question .links-body' do
        expect(page).to have_link 'My google', href: url
        expect(page).to have_content '2 * 3 = ?'
      end
    end

    scenario 'tries add links with errors', js: true do
      within(all('.nested-fields')[0]) do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'url'
      end

      click_on 'Save question'

      expect(page).to have_content 'Invalid format url'
      expect(page).to have_content "Links name can't be blank"
    end
  end
end
