# == Schema Information
#
# Table name: subscriptions
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  question_id :bigint(8)        not null
#

FactoryBot.define do
  factory :subscription do
    user { create(:user) }
    question { create(:question) }
  end
end
