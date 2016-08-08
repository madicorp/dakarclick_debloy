(($) ->
  user_id = $("#user_id").val()
  auction_id = $("#auction_id").val()
  sessionStorage.setItem('ours', user_id);
  # init Auction Socket
  auctionSocket = new AuctionSocket
  
  # onBid Action catch
  
  $("#send_bid_btn").click (e) ->
    e.preventDefault
    auctionSocket.sendBid user_id , auction_id
  
) jQuery, AuctionSocket