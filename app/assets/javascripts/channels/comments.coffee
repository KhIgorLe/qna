App.cable.subscriptions.create {channel: 'CommentsChannel', question_id: gon.question.id},
  connected: ->
    @perform 'follow'

  received: (data) ->
    if (data['comment_user_id'] != gon.current_user?.id)
      if(data['type'] == 'Question')
        $('.question-comments').append(data['comment'])
      else if(data['type'] == 'Answer')
        $('#answer_' + data['answer_id'] + ' ' + '.answer-comments').append(data['comment'])
