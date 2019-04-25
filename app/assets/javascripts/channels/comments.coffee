App.comments = App.cable.subscriptions.create { channel: "CommentsChannel", question_id: gon.question_id },
  connected: ->
    @perform 'follow',
  received: (data) ->
    comment = jQuery.parseJSON(data)
    $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append(comment.body)
