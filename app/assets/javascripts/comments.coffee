ready = ->
  $('.add-comment-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    $('#' + commentable_type + commentable_id + '-comments-form').show()

  PrivatePub.subscribe '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    $('#' + data.commentable_type + data.commentable_id + '-comments').append('<p>' + data.user_email + ': ' + comment.text + '</p>');
    $('#' + data.commentable_type + data.commentable_id + '-comments-form').hide()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('ajax:success', ready);
