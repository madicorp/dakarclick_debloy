(($) ->
  user_id = $("#user_id").val()
  sessionStorage.setItem('ours', user_id);
  # init Auction Socket
  auctionSocket = new AuctionSocket

  # onBid Action catch

  $(".send_home_btn").click (e) ->
    e.preventDefault
    input =  $(this).closest('.col-padd-custom').find("input[type=hidden]")
    auction_id = input.val()
    auctionSocket.sendBid user_id , auction_id

) jQuery, AuctionSocket
