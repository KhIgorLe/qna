class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, answer

    if answer.update(answer_params)
      render json: answer
    else
      render_json_errors(@answer)
    end
  end

  def destroy
    authorize! :update, answer

    answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question = Question.find(params[:question_id])
  end

  def answer
    @answer = Answer.find(params[:id])
  end

  def render_json_errors(resource)
    render json: resource.errors.full_messages, status: :unprocessable_entity
  end
end
