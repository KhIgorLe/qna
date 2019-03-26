# == Schema Information
#
# Table name: badges
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  question_id :bigint(8)        not null
#  user_id     :bigint(8)
#


FactoryBot.define do
  factory :badge do
    sequence :name do |n|
      "MyTextAnswer#{n}"
    end

    question
    user

    trait :attached do
      image { Rack::Test::UploadedFile.new('spec/fixtures/files/image.jpg', 'image/jpg') }
    end
  end
end
