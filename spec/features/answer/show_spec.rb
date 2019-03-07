require 'rails_helper'

feature 'users can view answers for question ', %q{
  In order to get answers for question from a community
  As an any user
  I'd like to be able to view all answers for question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Any users can view all answers for question' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
