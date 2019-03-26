require 'rails_helper'

feature 'user can delete attached links for answer', %q{
  In order to delete attached link for answer
  As an author answer
  I'd like to be able to delete attached links
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:links) { create_list(:link, 2, linkable: answer) }

  scenario 'Question author can delete attached links', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Edit answer'
    end

    within(all("#edit-answer-#{answer.id} .nested-fields")[0]) do
      click_on 'remove link'
    end

    click_on 'Save answer'

    within '.answers .links-body' do
      link = links[1]
      expect(page).to_not have_link link.name
    end
  end
end
