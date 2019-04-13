module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :delete_all, as: :commentable
  end
end
