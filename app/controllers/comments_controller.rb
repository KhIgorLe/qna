class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def set_commentable
    @commentable = Answer.find_by(id: params[:answer_id]) || Question.find_by(id: params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      channel,
      { comment: ApplicationController.render(partial: 'comments/comment', locals: { comment: @comment }),
        comment_user_id: @comment.user_id, type: @comment.commentable_type, answer_id: @comment.commentable.id }
    )
  end

  def channel
    if @comment.commentable_type == 'Question'
      "question/#{@comment.commentable.id}/comments"
    else
      "question/#{@comment.commentable.question.id}/comments"
    end
  end
end
