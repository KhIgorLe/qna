# == Schema Information
#
# Table name: badges
#
#  id          :bigint(8)        not null, primary key
#  name        :string           not null
#  question_id :bigint(8)        not null
#  user_id     :bigint(8)
#

class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image, dependent: :destroy

  validates :name, presence: true
end
