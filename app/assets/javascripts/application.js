// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery.turbolinks.min
//= require bootstrap-sprockets
//= require bootstrap-switch
//= require jquery.form
//= require jquery-duration-picker
//= require mustache
//= require meanmenu
//= require jquery.nivo.slider
//= require wow.min
//= require owl.carousel.min
//= require jquery.countdown.min
//= require jquery.fancybox.pack
//= require jquery.elevateZoom-3.0.8.min
//= require card
//= require main
//= require auction_websocket
//= require turbolinks
//= require order
//= require robot
//= require chat_websocket


    $(document).on('ready page:change page:load turbolinks:load',function (event) {
        (function ($) {
            "use strict";

            $('#ensign-nivoslider-3').nivoSlider({
                effect: 'random',
                slices: 15,
                boxCols: 8,
                boxRows: 4,
                animSpeed: 500,
                pauseTime: 5000,
                startSlide: 0,
                directionNav: true,
                controlNavThumbs: false,
                pauseOnHover: true,
                manualAdvance: false
            });



            //scroll to animation
            $("a[href^='#'][data-toggle!='modal'][data-toggle!='collapse']").click(function (e) {
                e.preventDefault();
                var margin = 50;
                if ($(document).scrollTop() <= 180)
                {
                    margin += 50;
                }
                var element = $(this).attr("href");
                $("html, body").animate({scrollTop: $(element).offset().top - margin }, 2000);
                return false;
            });

            $(document).scroll(function(e){
                var scrollTop = $(document).scrollTop();
                if(scrollTop > 200){
                    $("#scrollUp").css("display","block");
                }else{
                    $("#scrollUp").css("display","none");
                }
                if(scrollTop >= 180){
                    $('.menu-area').removeClass('navbar-static-top').addClass('navbar-fixed-top');
                } else {
                    $('.menu-area').removeClass('navbar-fixed-top').addClass('navbar-static-top');
                }
            });
        })(jQuery);
    });



