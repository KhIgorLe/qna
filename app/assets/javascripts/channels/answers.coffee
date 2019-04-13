App.cable.subscriptions.create {channel: 'AnswersChannel', question_id: gon.question.id},
  connected: ->
    @perform 'follow'

  received: (data) ->
    if (data['answer'].user_id != gon.current_user?.id)
      $('.answers').append(JST["templates/answer"](data));
