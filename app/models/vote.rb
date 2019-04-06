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

class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :rating, presence: true
  validates :rating, inclusion: (-1..1)

  validates :user_id, uniqueness: { scope: [:voteable_type, :voteable_id] }
end
