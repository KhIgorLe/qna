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
  factory :question do
    sequence :title do |n|
      "MyStringQuestion#{n}"
    end

    body { 'MyTextQuestion' }
    user

    trait :invalid do
      title { nil }
    end

    trait :attached do
      files { Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg') }
    end
  end
end
