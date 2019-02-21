# == Schema Information
#
# Table name: questions
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
