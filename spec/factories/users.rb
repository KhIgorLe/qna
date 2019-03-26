# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@test.com"
    end

    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
