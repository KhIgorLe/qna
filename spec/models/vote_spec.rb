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

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:rating) }
  it { should validate_inclusion_of(:rating).in_range(-1..1) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:voteable_type, :voteable_id) }
end
