class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_question, only: :create

  authorize_resource except: %i[update destroy]

  def index
    @questions = Question.all
    gon.question = question
  end

  def show
    @answer = question.answers.new

    gon.current_user = current_user
    gon.question = question
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
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: 'Question delete successfully'
  end

  private

  helper_method :question

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions',
       ApplicationController.render(partial: 'questions/question', locals: { question: question })
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy], badge_attributes: [:name, :image])
  end
end
