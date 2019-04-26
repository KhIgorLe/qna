class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :me, current_user
    render json: current_user
  end

  def index
    authorize! :index, current_user
    @users = User.where.not(id: current_user.id)
    render json: @users
  end
end
