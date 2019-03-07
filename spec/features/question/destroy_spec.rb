require 'rails_helper'

feature 'user can delete his question', %q{
  In order to delete question from a community
  As an question  author
  I'd like to be able to delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Question author can delete question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question delete successfully'
    expect(page).to_not have_content question.body
  end

  context 'Non author' do
    given(:another_user) { create(:user) }

    scenario 'tries delete question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
