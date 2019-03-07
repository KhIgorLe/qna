require 'rails_helper'

feature 'user can view list of all questions', %q{
  In order to get list of questions from a community
  As an any user
  I'd like to be able to view list of all questions
} do

  given!(:questions) { create_list(:question, 4) }

  scenario 'Any users can view list of all questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end

