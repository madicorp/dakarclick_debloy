var AuctionSocket = function(user_id, auction_id, form) {
  this.user_id = user_id;
  this.auction_id = auction_id;
  this.form = $(form);

  this.socket = new WebSocket(App.websocket_url + 'auctions/' + this.auction_id);

  this.initBinds();
};

AuctionSocket.prototype.initBinds = function() {
  var _this = this;

  this.form.submit(function(e) {
    e.preventDefault();
    _this.sendBid();
  });

  this.socket.onmessage = function(e) {

    var tokens = e.data.split(' ');

    switch(tokens[0]) {
      case 'bidok':
        _this.bid(tokens[1], tokens[2], tokens[3], tokens[4]);
        break;
      case 'outbid':
        _this.outbid(tokens[1],tokens[2]);
        break;
      case 'won':
        _this.won();
        break;
      case 'lost':
        _this.lost();
        break;
    }
    console.log(e);
  };
};

AuctionSocket.prototype.sendBid = function() {
  var template = "bid {{auction_id}} {{user_id}}";
  this.socket.send(Mustache.render(template, {
    user_id: this.user_id,
    auction_id: this.auction_id
  }));
};

AuctionSocket.prototype.bid = function(value,units,nbEnch, auction_close) {

    $('.messunits').html(units+ 'Unités');

    $('.nbench').html(nbEnch+ ' Enchères');


    $('.infogagn').html('Félicitations ,vous êtes temporairement le gagnant.')


    $('.desprice').html(
        value + 'FCFA'
    );
    $('.infogagn').addClass('infogagn_inverse').removeClass('infogagn');

    $('.infogagn_inverse').animateinfogagn('wobble');

    $('.desprice').addClass('desprice_inverse').removeClass('desprice');

    $('.desprice_inverse').animateCss('pulse');

};

AuctionSocket.prototype.outbid = function(value, nbEnch) {
    $('.nbench').html(nbEnch+ ' Enchères');

    $('.infogagn').html('Ooopss. Vous êtes hors enchère en ce moment.')


    $('.desprice').html(
      value + 'FCFA'
    );
    $('.infogagn').addClass('infogagn_inverse').removeClass('infogagn');

    $('.infogagn_inverse').animateinfogagn('wobble');

    $('.desprice').addClass('desprice_inverse').removeClass('desprice');

    $('.desprice_inverse').animateCss('pulse');

};


$.fn.extend({
    animateinfogagn: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        $(this).addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
            $(this).addClass('infogagn').removeClass('infogagn_inverse');
        });
    },

    animateCss: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        $(this).addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
            $(this).addClass('desprice').removeClass('desprice_inverse');
        });
    }
});
