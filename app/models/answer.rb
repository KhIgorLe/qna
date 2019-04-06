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
  include Voteable

  default_scope { order(best: :desc) }

  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  def make_best!
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      set_badge! if question.badge.present?
    end
  end

  private

  def set_badge!
    question.badge.update!(user: user)
  end
end
