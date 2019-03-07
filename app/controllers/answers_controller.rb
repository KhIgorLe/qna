class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_author_answer, only: :destroy

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy
    redirect_to question_path(question), notice: 'Answer delete successfully'
  end

  private

  def not_author_answer
    return if current_user.author_of?(answer)

    redirect_to question_path(question), notice: 'You can only delete your answer'
  end

  def question
     @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
