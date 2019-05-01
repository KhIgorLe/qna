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
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'call ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'scope today' do
    let!(:questions) { create_list(:question, 3) }

    it 'return questions created today' do
      expect(Question.today.size).to eq 3
    end

    it 'return correct attributes' do
      expect(Question.today.first.title).to eq questions.first.title
    end
  end

  describe '#subscribe' do
    let(:other_user) { create(:user) }
    let(:question) { create(:question) }

    before do
      question.subscribe(other_user)
    end

    it 'create subscription for user' do
      expect(Subscription.last.user).to eq other_user
      expect(Subscription.last.question).to eq question
    end
  end

  describe '#unsubscribe' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    before do
      question.unsubscribe(user)
    end

    it 'delete subscription for user' do
      expect(Subscription.first).to eq nil
    end
  end

  describe '#subscribe_author' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'subscription on create & commit' do
      expect(question).to receive :subscribe_author
      question.save
    end

    context 'create subscription' do
      let(:question) { create(:question, user: user) }

      before do
        question.subscribe(user)
      end

      it 'create subscription for author' do
        expect(Subscription.first.question).to eq question
        expect(Subscription.first.user).to eq user
      end
    end
  end
end
