# == Schema Information
#
# Table name: subscriptions
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  question_id :bigint(8)        not null
#

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question
end
