ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question').show()

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('ul.list-group').append("<li class='list-group-item'><a href='/questions/"
                              + question.id + "'>" + question.title + "</a></li>");

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('ajax:success', ready);
