class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :not_author_answer, only: %i[update destroy]
  before_action :not_author_question, only: :make_best

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def edit
  end

  def update
    answer.update(answer_params)

    @question = answer.question
  end

  def destroy
    answer.destroy
  end

  def make_best
    answer.make_best!
  end

  private

  def chanel
    "question/#{question.id}/answers"
  end

  def not_author_answer
    return if current_user.author_of?(answer)

    redirect_to root_path, notice: 'You can only delete your answer'
  end

  def not_author_question
    return if current_user.author_of?(question)

    redirect_to root_path, notice: 'You can make best answer only for your question'
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
