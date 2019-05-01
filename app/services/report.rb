class Services::Report

  def send_report(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      ReportMailer.send_report(subscription.user, answer).deliver_later
    end
  end
end
