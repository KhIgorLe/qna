# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :me, User, id: user.id

    can :up_rating, [Question, Answer] do |object|
      !user.author_of?(object) && !user.voted?(object)
    end

    can :down_rating, [Question, Answer] do |object|
      !user.author_of?(object) && !user.voted?(object)
    end

    can :un_rating, [Question, Answer] do |object|
      user.voted?(object)
    end

    can :make_best, Answer do |answer|
      user.author_of?(answer.question) && !answer.best?
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
  end
end
