require 'rails_helper'

RSpec.describe Services::Report do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }
  let(:subscription) { create(:subscription, user: user, question: question) }
  let(:not_subscribed) { create_list(:user, 2) }

  it 'sends report to all subscriptions user' do
    answer.question.subscriptions.each do |subscription|
      expect(ReportMailer).to receive(:send_report).twice.with(subscription.user, answer).and_call_original
      subject.send_report(answer)
    end
  end

  it 'not sends report not subscribed users' do
    answer.question.subscriptions.each do |subscription|
      expect(subscription.user).to_not eq not_subscribed.first
      expect(subscription.user).to_not eq not_subscribed.last
    end
  end
end
