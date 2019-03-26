require 'rails_helper'

feature 'User can add links when editing answer', %q{
  In order to change additional info to my answer
  As an answer author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }
  given(:url) { 'http://google.com' }
  given(:gist_url) { 'https://gist.github.com/KhIgorLe/2bfafe90ab91aa1f4b468e9746f613a0' }

  describe 'Authenticated user ' do
    background do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit answer'
      end

      within '.answers .links' do
        click_on 'add link'
      end
    end

    scenario 'can adds links', js: true do

      within(all("#edit-answer-#{answer.id} .nested-fields")[1]) do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      click_on 'Save answer'

      within '.answers' do
        expect(page).to have_link link.name, href: link.url
        expect(page).to have_content '2 * 3 = ?'
      end
    end

    scenario 'tries add links with errors', js: true do
      within(all("#edit-answer-#{answer.id} .nested-fields")[0]) do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'url'
      end

      click_on 'Save answer'

      expect(page).to have_content 'Invalid format url'
      expect(page).to have_content "Links name can't be blank"
    end
  end
end

