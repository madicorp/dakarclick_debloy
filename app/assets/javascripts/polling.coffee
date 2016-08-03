window.Poller = {
  poll: (timeout) ->
    if timeout is 0
      Poller.request()
#    else
#      this.pollTimeout = setTimeout ->
#        Poller.request()
#      , timeout || 5000
  clear: -> clearTimeout(this.pollTimeout)
  request: ->
    $.get('/comments')
}

jQuery ->
  Poller.poll() if $('#comments').size() > 0
return
