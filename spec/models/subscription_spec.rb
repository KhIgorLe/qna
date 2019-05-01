# == Schema Information
#
# Table name: subscriptions
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)        not null
#  question_id :bigint(8)        not null
#

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
end
