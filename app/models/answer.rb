# == Schema Information
#
# Table name: answers
#
#  id          :bigint(8)        not null, primary key
#  body        :text
#  question_id :bigint(8)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint(8)        not null
#  best        :boolean          default(FALSE), not null
#

class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def make_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
