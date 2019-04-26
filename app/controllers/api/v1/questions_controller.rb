class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource except: %i[update destroy]

  def index
    @questions = Question.all

    render json: @questions
  end

  def show
    render json: question
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      render json: @question
    else
      render_json_errors(@question)
    end
  end

  def update
    authorize! :update, question

    if question.update(question_params)
      render json: question
    else
      render_json_errors(@question)
    end
  end

  def destroy
    authorize! :update, question

    question.destroy
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def render_json_errors(resource)
    render json: resource.errors.full_messages, status: :unprocessable_entity
  end
end
