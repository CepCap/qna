App.answers = App.cable.subscriptions.create { channel: "AnswersChannel", question_id: gon.question_id },
  connected: ->
    @perform 'follow',

  received: (data) ->
    answer = jQuery.parseJSON(data)
    $('.answers').append(JST["answer"]({answer: answer}))
