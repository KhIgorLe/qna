require 'rails_helper'

feature 'user can select best answer for question', %q{
  In order to select best answer for question
  As an author of questions
  I'd like can select best answer for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'owner question' do
    scenario 'tries select best answer for question', js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_on 'Best answer'

        expect(page).to_not have_link 'Best answer'
        expect(page).to have_content 'This is best answer'
      end
    end
  end

  context 'not author question', js: true do
    given(:another_user) { create(:user) }
    given!(:another_user_answer) { create(:answer, question: question, user: another_user) }

    background do
      another_user_answer.make_best!
      question.reload
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'tries select best answer for question' do
      expect(page).to_not have_link 'Best answer'
    end

    scenario 'can see best answer for question' do
      within "#answer_#{answer.id}" do
        expect(page).to_not have_content 'This is best answer'
      end

      within "#answer_#{another_user_answer.id}" do
        expect(page).to have_content 'This is best answer'
      end
    end
  end

  scenario 'Unauthenticated user tries select best answer for question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
