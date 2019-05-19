# == Schema Information
#
# Table name: comments
#
#  id               :bigint(8)        not null, primary key
#  body             :text             not null
#  commentable_type :string
#  commentable_id   :bigint(8)
#  user_id          :bigint(8)
#

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, presence: true
end
