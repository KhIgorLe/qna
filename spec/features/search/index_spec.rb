require 'sphinx_helper'

feature 'user can search questions, answers, comments, users', %q{
  In order to get list of questions, answers, comments, users  from a community
  As an any user
  I'd like to be able search information
} do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, body: 'Question') }
  let!(:question) { create(:question, title: 'latest Question', body: 'the body') }
  let!(:answer) { create(:answer, question: question, user: user, body: 'latest answer') }
  let!(:comment) { create(:comment, commentable: question, user: user, body: 'latest comment') }

  scenario 'search globally', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest'
      select('Global search', from: 'type')
      click_on 'Search'

      expect(current_path).to eq search_path

      expect(page).to have_content 'latest answer'
      expect(page).to have_content 'latest comment'
      expect(page).to have_content 'latest Question'
    end
  end

  scenario 'search a question', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'the body'
      select('Question', from: 'type')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'latest Question'
    end
  end

  scenario 'search answer', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest answer'
      select('Answer', from: 'type')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'latest answer'
    end
  end

  scenario 'search comment', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: 'latest comment'
      select('Comment', from: 'type')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'latest comment'
    end
  end

  scenario 'search users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: question.user.email
      select('User', from: 'type')
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content question.user.email
    end
  end

  scenario 'search blank query', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'query', with: ''
      click_on 'Search'

      expect(current_path).to eq search_path
      expect(page).to have_content 'No results.'
    end
  end
end
