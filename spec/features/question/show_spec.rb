require 'rails_helper'

feature 'user can view question', %q{
  In order to see question from a community
  As an any user
  I'd like to be able to view question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Any users can view question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
