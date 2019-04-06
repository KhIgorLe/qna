# == Schema Information
#
# Table name: votes
#
#  id            :bigint(8)        not null, primary key
#  rating        :integer          default(0), not null
#  voteable_type :string
#  voteable_id   :bigint(8)
#  user_id       :bigint(8)        not null
#

FactoryBot.define do
  factory :vote do

  end
end
