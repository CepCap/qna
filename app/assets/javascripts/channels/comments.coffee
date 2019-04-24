App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    @perform 'follow',
  received: (data) ->
    comment = jQuery.parseJSON(data)
    $('.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append(comment.body)
