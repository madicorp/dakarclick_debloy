(($) ->
  user_id = $("#user_id").val()
  sessionStorage.setItem('ours', user_id);
  # init Auction Socket
  auctionSocket = new AuctionSocket

  # onBid Action catch
  console.log($(".send_home_btn"))
  $(".send_home_btn").on "click", (e)->
    e.preventDefault
    console.log("home bid button", "clicked")
    input =  $(this).closest('.col-padd-custom').find("input[type=hidden]")
    auction_id = input.val()
    auctionSocket.sendBid user_id , auction_id
    return false

) jQuery, AuctionSocket
