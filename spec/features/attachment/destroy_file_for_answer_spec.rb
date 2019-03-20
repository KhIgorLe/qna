require 'rails_helper'

feature 'user can delete attached files for answer', %q{
  In order to delete attached files for answer
  As an answer author
  I'd like to be able to delete attached files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, :attached, user: user) }
  given!(:answer) { create(:answer, :attached, question: question, user: user) }

  let(:file) { 'image.jpg' }

  scenario 'Answer author can delete attached files', js: true do
    sign_in(user)
    visit question_path(question)

    within "#attachment_#{answer.files.first.id}" do
      click_on 'Delete file'
    end

    within '.answers' do
      expect(page).to_not have_link file
    end
  end

  context 'Non author' do
    given(:another_user) { create(:user) }

    scenario 'tries delete attached files', js: true do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries delete attached files', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end
