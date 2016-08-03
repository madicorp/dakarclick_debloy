# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->
  $(document).on 'ready page:change',(event)  ->
    #----------------------------
    #     bootstrap switch function
    #------------------------------
    $(".activate-robots").bootstrapSwitch()
    $(".activate-robots").on 'switchChange.bootstrapSwitch', (event, state) ->
      if state
        $(".robot-config-area").removeClass "hide"
      else
        $(".robot-config-area").addClass "hide"
        action = $("form.form_robot").attr('action')
        success = (data) ->
          console.log data
          if data.reponse != null
            try
              object = JSON.parse data.reponse
              auctionSocket = new AuctionSocket object.user_id, object.auction_id, $("#new_bid")
              auctionSocket.socket.onopen = (e) ->
                auctionSocket.createRobotSocket data.reponse
            catch e
              console.log e

        $("form.form_robot").ajaxSubmit {success: success},action,'post'

    #-------------------------------
    #    Date Picker ..
    #-------------------------------
    $(".timepicker").durationPicker { showSeconds: true }

    #-------------------------------
    #   submit robot ..
    #-------------------------------
    $(".form_robot").submit (event) ->
      event.preventDefault()
      $(this).ajaxSubmit success: (data) ->
        if data.reponse != null
          try
            object = JSON.parse data.reponse
            auctionSocket = new AuctionSocket object.user_id, object.auction_id, $("#new_bid")
            auctionSocket.socket.onopen = (e) ->
              auctionSocket.createRobotSocket data.reponse
          catch e
            console.log e
      return false
) jQuery
