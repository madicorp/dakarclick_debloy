var AuctionSocket = function(user_id, auction_id, form) {
    this.user_id = sessionStorage.getItem('ours');
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
        var data ="";
        try {
             data = JSON.parse(e.data);

        }catch (e){
            console.log(e);
        }

        switch(data.message) {
            case 'bidok':
                _this.bid(data);
                break;
            case 'outbid':
                _this.outbid(data);
                break;
            case 'won':
                _this.won();
                break;
            case 'createrobotok':
                _this.createrobot(data);
                break;
            case 'lost':
                _this.lost();
                break;

            case 'robot_off':
                alert("off");
                break;
        }
        console.log(e);
    };
};

AuctionSocket.prototype.sendBid = function() {
    var template = {"action": 'bid', "auction_id" : '{{auction_id}}', "user_id" : '{{user_id}}'};
    this.socket.send(Mustache.render(JSON.stringify(template), {
        user_id: this.user_id,
        auction_id: this.auction_id
    }));
};

AuctionSocket.prototype.createRobotSocket = function(template) {
    this.socket.send(Mustache.render(template, {
        user_id: this.user_id,
        auction_id: this.auction_id
    }));
};

AuctionSocket.prototype.bid = function(data) {

    $('.messunits').html(data.units+ 'Unités');

    $('.nbench').html(data.ench+ ' Enchères');
    console.log(data.user_id+ " ..... "+this.user_id);
    if(data.user_id == this.user_id){
        $('#infogagn').html('Félicitations ,vous êtes temporairement le gagnant.')
    }
    else {
        $('#infogagn').html('Ooopss. Vous êtes hors enchère en ce moment.')
    }


    $('.desprice').html(
        data.value + 'FCFA'
    );
    $('#infogagn').addClass('infogagn_inverse').removeClass('infogagn');

    $('.infogagn_inverse').animateinfogagn('wobble');

    $('.desprice').addClass('desprice_inverse').removeClass('desprice');

    $('.desprice_inverse').animateCss('pulse');

    // $('#countdownauction').attr("data-countdown", auction_close);
    //
    // $('#countdownauction').attr("data-countdown", function() {
    //     var $this = $(this),
    //         finalDate = auction_close;
    //
    //     $this.countdown(finalDate, function(event) {
    //         $this.html(event.strftime('<span class="cdown days"><span class="time-count">%-D<span>J</span></span></span><span class="cdown hour"><span class="time-count">%-H<span>H</span></span></span><span class="cdown minutes"><span class="time-count">%M<span>M</span></span></span> <span class="cdown second"><span class="time-count">%S<span>S</span></span></span>'));
    //     });
    // });

    if(data.disable_robot_id !== "undefined" && data.disable_robot_id != null){
        $("#robot_"+data.disable_robot_id).bootstrapSwitch('state', false, false);
        $("#conteur_"+data.disable_robot_id).addClass("hide")
        $("#send_bid_btn").prop('disabled', true);
    }

};

AuctionSocket.prototype.outbid = function(data) {
    $('.nbench').html(data.ench+ ' Enchères');
    if(data.user_id == this.user_id){
        $('#infogagn').html('Félicitations ,vous êtes temporairement le gagnant.')

    }
    else {
        $('#infogagn').html('Ooopss. Vous êtes hors enchère en ce moment.')
        console.log("pas ok");
    }


    $('.desprice').html(
        data.value + 'FCFA'
    );
    $('#infogagn').addClass('infogagn_inverse').removeClass('infogagn');

    $('.infogagn_inverse').animateinfogagn('wobble');

    $('.desprice').addClass('desprice_inverse').removeClass('desprice');

    $('.desprice_inverse').animateCss('pulse');

    if(data.disable_robot_id !== "undefined" && data.disable_robot_id != null){
        $("#robot_"+data.disable_robot_id).bootstrapSwitch('state', false, false);
        $("#conteur_"+data.disable_robot_id).addClass("hide")
        $("#send_bid_btn").prop('disabled', false);

    }

};

AuctionSocket.prototype.createrobot = function (data) {
    $(".robot-config-area").addClass("hide");
    $("#send_bid_btn").prop('disabled', true);
    $("#conteur_"+data.user_id+""+data.auction_id).removeClass("hide");
    $("#conteur_"+data.user_id+""+data.auction_id).find('div').attr('data-countdown',data.robot_ends_at);
    var $this = $("#conteur_"+data.user_id+""+data.auction_id).find('div'),
        finalDate = $("#conteur_"+data.user_id+""+data.auction_id).find('div').data('countdown');
    $this.countdown(finalDate, function(event) {

        $this.html(event.strftime('<span class="cdown days"><span class="time-count">%-D<span>J</span></span></span><span class="cdown hour"><span class="time-count">%-H<span>H</span></span></span><span class="cdown minutes"><span class="time-count">%M<span>M</span></span></span> <span class="cdown second"><span class="time-count">%S<span>S</span></span></span>'));
        if(event.type == 'finish')
        {
            console.log(event);
        }

    });
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
