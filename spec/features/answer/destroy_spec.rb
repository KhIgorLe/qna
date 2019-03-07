require 'rails_helper'

feature 'user can delete his answer', %q{
  In order to delete answer from a community
  As an answer  author
  I'd like to be able to delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Answer author can delete answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer delete successfully'
    expect(page).to_not have_content answer.body
  end

  context 'Non author answer' do
    given(:another_user) { create(:user) }

    scenario 'tries delete answer' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end
