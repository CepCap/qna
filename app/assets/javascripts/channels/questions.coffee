App.questions = App.cable.subscriptions.create { channel: "QuestionsChannel"},
  connected: ->
    @perform 'follow',

  received: (data) ->
    $('.questions-list').append(data)
