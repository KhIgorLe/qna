# == Schema Information
#
# Table name: answers
#
#  id          :bigint(8)        not null, primary key
#  body        :text
#  question_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
end
