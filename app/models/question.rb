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

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true
end
