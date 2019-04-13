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
  include Commentable

  default_scope { order(best: :desc) }

  after_create_commit :broadcast_answer

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

  def broadcast_answer
    ActionCable.server.broadcast "question/#{question.id}/answers", answer_data
  end

  def answer_data
    data = {}
    data[:answer] = self
    data[:files] = files_data
    data[:links] = links_data
    data[:rating] = rating

    data
  end

  def files_data
    data =[]
    files.each do |file|
      data << {
        file_name: file.filename.to_s,
        file_id: file.id,
        file_url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end

    data
  end

  def links_data
    data = []
    links.each do |link|
      links_data = { link_name: link.name, link_url: link.url }
      links_data[:gist_content] = link.gist_contents  if link.gist_link?
      data << links_data
    end

    data
  end
end
