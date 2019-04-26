class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :user_id, :created_at, :updated_at, :attachments

  has_many :comments
  belongs_to :user
  has_many :links

  def attachments
    object.files.map do |file|
      { id: file.id, url: rails_blob_path(file, only_path: true) }
    end
  end
end
