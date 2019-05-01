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
  include Voteable
  include Commentable

  scope :today, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day ) }

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  has_one :badge, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: proc { |attributes| attributes['image'].blank? }

  has_many_attached :files

  validates :title, :body, presence: true

  after_create :calculate_reputation

  after_create :subscribe_author

  def subscribe(current_user)
    subscriptions.create!(user_id: current_user.id)
  end

  def unsubscribe(current_user)
    subscriptions.find_by(user_id: current_user.id).destroy
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    subscriptions.create!(user_id: user.id)
  end
end
