# == Schema Information
#
# Table name: authorizations
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
  end
end
