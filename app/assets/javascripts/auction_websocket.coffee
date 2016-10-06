(($) ->
  # define Auction socket Init
  class @AuctionSocket
    constructor: ->
      protocol = ' ws://'
      if (location.protocol == "https:")
        protocol = "wss://"
      hostname = location.hostname
      port = ':' + location.port
      if (location.port == "undefined" || location.port == '')
        port = ''
      @socket =  new ReconnectingWebSocket(protocol + hostname + port);
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
        switch data.message
          when 'bidok'  then  self.bid(data)
          when 'outbid' then  self.bid(data)
          when 'won'    then  self.won(data)
          when 'createrobotok' then  self.createrobot(data)
          when 'lost' then  self.lost(data)
          else  console.info data

    # Auction socket Send Message function
    sendBid: (user_id, auction_id) ->
      template = {"action": 'bid', "auction_id" : '{{auction_id}}', "user_id" : '{{user_id}}'}
      @socket.send Mustache.render(JSON.stringify(template), {user_id: user_id, auction_id: auction_id})

    # Auction create robot function
    createRobotSocket: (template,user_id, auction_id) ->
      @socket.send Mustache.render(JSON.stringify template , {user_id: user_id, auction_id: auction_id})

    # Auction WON
    won: (data) ->
      location.href = "/"
    # Auction bid function to update informations
    bid: (data) ->
      $('.nbench').html(data.ench+ ' Enchères')
      last_users = data.last_users
      $('.auction'+data.auction_id).find('.av_winner').html('')
      i= 1
      first = 'first'
      for user in data.last_users
        if user
          $('.auction'+data.auction_id).find('.av_winner').append("<div class='winner "+first+"'>"+i + "- "+user+"</div>")
        else
          $('.auction'+data.auction_id).find('.av_winner').append("<div class='winner'>-</div>")
        i++
        first=""
      $('.auction'+data.auction_id).find('.price').html(data.value)
      timer = $('.auction'+data.auction_id).find('.timer_alert')
      $(timer).data("countdown", data.auction_close)
      finalDate = data.auction_close
      finish = new Date(new Date(finalDate))
      now = new Date
      diff = finish.getTime() - now.getTime()
      seconds = (new Date(new Date(finalDate)) - ServerDate) / 1000
      $(timer).timeTo {
          seconds: seconds,
          displayDays: 2,
          fontSize: 20,
          countdownAlertLimit: 30,
          callback: ->
            auction_id = $(this).data("auctionid")
            auction_type = $(this).data("auctiontype")
            if auction_type == "active"
              $.post("/auctions/ended", {"auction_id" : auction_id, "auction_type": auction_type}).done (data) ->
                toastr.info('L\'enchère '+data.auction+' est terminée , '+data.winner+' gagne !')
        }
      if (diff / 1000) > 30
        $('.auction'+data.auction_id).find("[data-countdown]").children("div").each ->
          $(this).removeClass('timeTo-alert')
      user_id =  parseInt(sessionStorage.getItem('ours'))
      if(data.user_id == user_id)
        $('#infogagn').html('Félicitations ,vous êtes temporairement le gagnant.')
        if data.units
          $('.messunits').html(data.units+ 'Unités')
      else
        $('#infogagn').html('Ooopss. Vous êtes hors enchère en ce moment.')

      $('.desprice').html(data.value)

      $('#infogagn').addClass('infogagn_inverse').removeClass('infogagn')
      $('.infogagn_inverse').animateCss('wobble','infogagn','infogagn_inverse')

      $('.desprice').addClass('desprice_inverse').removeClass('desprice')
      $('.desprice_inverse').animateCss('pulse', 'desprice_inverse','desprice')

      if(data.disable_robot_id != undefined && data.disable_robot_id != null)
        $("#robot_" + data.disable_robot_id).bootstrapSwitch('state', false, false)
        $("#conteur_" + data.disable_robot_id).addClass("hide")
        $("#send_bid_btn").prop('disabled', true)


    # Auction create robot funcrtion update robot form
    createrobot: (data) ->
      $(".robot-config-area").addClass("hide")
      $("#send_bid_btn").prop('disabled', true)
      $("#conteur_"+data.user_id+""+data.auction_id).removeClass("hide")
      $("#conteur_"+data.user_id+""+data.auction_id).find('div').attr('data-countdown',data.robot_ends_at)
      $this = $("#conteur_"+data.user_id+""+data.auction_id).find('div')
      finalDate = $("#conteur_"+data.user_id+""+data.auction_id).find('div').data('countdown')
      $this.countdown finalDate,(event) ->
        $this.html(event.strftime('<span class="cdown days"><span class="time-count">%-D<span>J</span></span></span><span class="cdown hour"><span class="time-count">%-H<span>H</span></span></span><span class="cdown minutes"><span class="time-count">%M<span>M</span></span></span> <span class="cdown second"><span class="time-count">%S<span>S</span></span></span>'))

  # JQUERY EXTEND ANIMATION FUNCTION
  $.fn.extend {
    animateCss: (animationName , oldClass, newClass) ->
      animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend'
      $(this).addClass('animated ' + animationName).one animationEnd, ->
        $(this).removeClass('animated ' + animationName)
        $(this).addClass(oldClass).removeClass(newClass)
  }

) jQuery
