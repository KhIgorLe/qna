class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!

  authorize_resource except: %i[update destroy]

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def edit
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)

    @question = answer.question
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def make_best
    authorize! :make_best, answer
    answer.make_best!
  end

  private

  def chanel
    "question/#{question.id}/answers"
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
