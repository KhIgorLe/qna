require 'rails_helper'

feature 'User can add links for answer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}
  given(:url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/KhIgorLe/2bfafe90ab91aa1f4b468e9746f613a0' }


  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Test answer body'

      within '.new-answer .links' do
        click_on 'add link'
      end
    end

    scenario 'can adds links', js: true do
      within(all('.new-answer .nested-fields')[0]) do
        fill_in 'Link name', with: 'My google'
        fill_in 'Url', with: url
      end

      within '.new-answer .links' do
        click_on 'add link'
      end

      within(all('.new-answer .nested-fields')[1]) do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Give answer'

      within '.answers .links-body' do
        expect(page).to have_link 'My google', href: url
        expect(page).to have_content '2 * 3 = ?'
      end
    end

    scenario 'tries add links with errors', js: true do
      within(all('.new-answer .nested-fields')[0]) do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'url'
      end

      click_on 'Give answer'

      expect(page).to have_content 'Invalid format url'
      expect(page).to have_content "Links name can't be blank"
    end
  end
end
