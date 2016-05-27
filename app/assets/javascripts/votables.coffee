ready = ->
  $('.buttons').bind 'ajax:success', (e, data, status, xhr) ->
    response = xhr.responseJSON
    $('#' + response.model + response.id + ' .rating').html('Rating: ' + response.rating);
    if response.voted
      $('#vote_up-' + response.model + response.id).attr('disabled',true);
      $('#vote_down-' + response.model + response.id).attr('disabled',true);
      $('#remove_vote-' + response.model + response.id).attr('disabled',false);
    else
      $('#vote_up-' + response.model + response.id).attr('disabled',false);
      $('#vote_down-' + response.model + response.id).attr('disabled',false);
      $('#remove_vote-' + response.model + response.id).attr('disabled',true);

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
