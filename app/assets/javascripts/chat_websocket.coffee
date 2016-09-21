(($) ->
# define Auction socket Init
  class @ChatSocket
    constructor: ->
      protocol = ' ws://'
      if (location.protocol == "https:")
        protocol = "wss://"
      hostname = location.hostname
      port = ':' + location.port
      if (location.port == "undefined" || location.port == '')
        port = ''
      @socket =  new ReconnectingWebSocket(protocol + hostname + port, null,{debug: true, reconnectInterval: 1000})
      @socket.onclose = (e) ->
        console.log("Refresh Websocket !")
      self = @
      @socket.onmessage = (e) ->
        console.log e
        data = ""
        try
          data = JSON.parse e.data
        catch e
          console.info e
        switch data.action
          when 'chatnotifother'  then  self.chatnotifother(data)
          else  console.info data
    sendMessage: (user_id, message) ->
      template = {"action": 'chat', "user_id" : '{{user_id}}', "message" : '{{message}}'}
      @socket.send Mustache.render(JSON.stringify(template), {user_id: user_id, message: message})

    chatnotifother: (data) ->
      $.get("/comments/refresh")
) jQuery