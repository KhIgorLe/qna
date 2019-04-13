class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "question/#{params[:question_id]}/answers"
  end
end
