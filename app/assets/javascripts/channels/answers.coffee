App.answers = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    @perform 'follow',

  received: (data) ->
    answer = jQuery.parseJSON(data)
    $('.answers').append(JST["answer"]({answer: answer}))
