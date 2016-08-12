(($) ->
  user_id = $("#user_id").val()
  sessionStorage.setItem('ours', user_id);
# init Auction Socket
  chatSocket = new ChatSocket
  $('.new_comment').submit (e)->
    e.preventDefault
    $('.new_comment').ajaxSubmit {url: '/comments', type: 'post'}
    chatSocket.sendMessage(user_id, $("#comment_body").val())
    $("#comment_body").val('')
    return false;
  $(".send_message").click (e) ->
    e.preventDefault
    $('.new_comment').ajaxSubmit {url: '/comments', type: 'post'}
    chatSocket.sendMessage(user_id, $("#comment_body").val())
    $("#comment_body").val('')
) jQuery, ChatSocket