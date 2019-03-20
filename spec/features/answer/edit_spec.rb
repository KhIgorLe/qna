require 'rails_helper'

feature 'user can edit his answer', %q{
  In order to edit mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  describe 'answer owner' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit answer'
    end

    scenario 'tries edit answer', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'New body'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'New body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries edit answer with errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save answer'
      end

      within '.answer_errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'tries edit other user answer', js: true do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  scenario 'Unauthenticated user tries edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end


