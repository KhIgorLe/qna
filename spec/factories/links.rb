# == Schema Information
#
# Table name: links
#
#  id            :bigint(8)        not null, primary key
#  name          :string
#  url           :string
#  linkable_type :string
#  linkable_id   :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :link do
    sequence :name do |n|
      "google#{n}"
    end

    url { 'http://google.com' }

    trait :gist_link do
      url { 'https://gist.github.com/KhIgorLe/2bfafe90ab91aa1f4b468e9746f613a0' }
    end
  end
end
