# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint(8)        not null
#

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:badge).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'votable' do
    let(:owner_user) { create(:user) }
    let(:question) {create :question, user: owner_user }

    it_behaves_like 'has many votes'
    it_behaves_like 'voteable rating', 'question'
  end

  describe 'commentable' do
    it_behaves_like 'has many comments'
  end
end
