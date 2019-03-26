require 'rails_helper'

feature 'user can delete attached links for question', %q{
  In order to delete attached link for question
  As an author question
  I'd like to be able to delete attached links
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:links) { create_list(:link, 2, linkable: question) }

  scenario 'Question author can delete attached links', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit question'
    end

    within(all("#edit-question-#{question.id} .nested-fields")[0]) do
      click_on 'remove link'
    end

    click_on 'Save question'

    within '.question .links-body' do
      link = links[1]
      expect(page).to_not have_link link.name
    end
  end
end
