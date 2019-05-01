class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    # Do something later
    Services::Reputation.calculate(object)
  end
end
