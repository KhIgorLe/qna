require 'rails_helper'

feature 'User can sign up',%q{
  In order to ask questions
  I'd like to be able to sign in
} do

  background do
    visit new_user_session_path
    click_on 'Sign up'
  end

  scenario 'Unregistered user can sign up' do

    fill_in 'Email', with: 'user@qna.com'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
