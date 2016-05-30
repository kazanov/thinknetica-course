ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer' + answer_id).show()

  # questionId = $('#answers').data('questionId')
  # PrivatePub.subscribe '/questions/' + questionId + '/answers', (data, channel) ->
  #   console.log(data)
  #   answer = $.parseJSON(data['answer'])
  #   $('#answers').append('<p>' + answer.body + '</p>');

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('ajax:success', ready);
