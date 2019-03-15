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
  let(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 5, question: question, user: user) }
  let!(:answer) { create(:answer, question: question, best: true) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

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
  end

  describe 'default scope order' do
    it 'order answer by best 'do
      expect(question.answers.first).to eq answer
    end
  end
end
