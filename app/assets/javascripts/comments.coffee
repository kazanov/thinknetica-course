ready = ->
  $('.add-comment-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('.comments-form').show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on('ajax:success', ready);
