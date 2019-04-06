module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: %i[up_rating down_rating un_rating]
  end

  def up_rating
    render_json if @voteable.up_rating(current_user)
  end

  def down_rating
    render_json if @voteable.down_rating(current_user)
  end

  def un_rating
    render_json if @voteable.un_rating(current_user)
  end

  private

  def render_json
    render json: { rating: @voteable.rating, id: @voteable.id, klass: @voteable.class.to_s }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
