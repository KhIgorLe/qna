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

FactoryBot.define do
  sequence :title do |n|
    "MyStringQuestion#{n}"
  end

  factory :question do
    title
    body { 'MyTextQuestion' }
    user

    trait :invalid do
      title { nil }
    end
  end
end
