class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :not_author_question, only: %i[update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new
    @question = Question.new
    @question.badge = Badge.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question delete successfully'
  end

  private

  helper_method :question

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def not_author_question
    return if current_user.author_of?(question)

    redirect_to root_path, notice: 'You can only delete your question'
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], badge_attributes: [:name, :image])
  end
end
