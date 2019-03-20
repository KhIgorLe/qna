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

FactoryBot.define do
  sequence :body do |n|
    "MyTextAnswer#{n}"
  end

  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :attached do
      files { Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg') }
    end
  end
end
