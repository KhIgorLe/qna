# == Schema Information
#
# Table name: answers
#
#  id          :bigint(8)        not null, primary key
#  body        :text
#  question_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)        not null
#  best        :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:badge) { create(:badge, :attached) }
  let(:question) { create(:question, user: user, badge: badge) }
  let!(:answers) { create_list(:answer, 5, question: question, user: user) }
  let!(:answer) { create(:answer, question: question, best: true) }

  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of(:body) }

  describe '#make_best! answer for question' do
    let(:another_answer) { create(:answer, question: question)}

    before do
      another_answer.make_best!
      answer.reload
    end

    it 'answer for question not best'  do
      expect(answer).to_not be_best
    end

    it 'another answer best for question'  do
      expect(another_answer).to be_best
    end

    it '#set_badge! owner answer received badge' do
      expect(question.badge.user).to eq another_answer.user
    end
  end

  describe 'default scope order' do
    it 'order answer by best 'do
      expect(question.answers.first).to eq answer
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
