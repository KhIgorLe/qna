# == Schema Information
#
# Table name: badges
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  question_id :bigint(8)        not null
#  user_id     :bigint(8)
#

require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it { should validate_presence_of(:name) }

  it 'have one attached image' do
    expect(Badge.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
