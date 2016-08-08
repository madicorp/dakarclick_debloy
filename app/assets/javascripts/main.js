/**
 * Created by a621275 on 07/06/2016.
 */
$(document).ready(function () {
    /*----------------------------
     jQuery MeanMenu
     ------------------------------ */
    jQuery('nav#dropdown').meanmenu();
});
$(document).on('ready page:change', function(event) {

    //    toggle class
    $(".buy-btn span").on("click", function() {
        $(".header-top-area").toggleClass("btn-none");
    });

    /*---------------------
     tooltip
     --------------------- */
    $('[data-toggle="tooltip"]').tooltip({
        animated: 'fade',
        placement: 'top',
        container: 'body'
    });
    /*----------------------------
     wow js active
     ------------------------------ */
    new WOW().init();
    /*----------------------------
     Countdown active
     ------------------------------ */
    $('[data-countdown]').each(function() {
        var $this = $(this),
            finalDate = $(this).data('countdown');
        $this.countdown(finalDate, function(event) {

        $this.html(event.strftime('<span ><span>%-D<span>J</span></span></span><span><span>%-H<span>H</span></span></span><span><span>%M<span>M</span></span></span> <span><span>%S<span>S</span></span></span>'));
        }).on('update.countdown', function () {
            
        })
         .on('finish.countdown', function () {
             
         });
    });

    /*----------------------------
     owl active
     ------------------------------ */
    $(".total-product-slide").owlCarousel({
        autoPlay: false,
        slideSpeed: 2000,
        pagination: false,
        navigation: true,
        items: 3,
        /* transitionStyle : "fade", */
        /* [This code for animation ] */
        navigationText: false,
        itemsDesktop: [1199, 3],
        itemsDesktopSmall: [980, 3],
        itemsTablet: [768, 2],
        itemsMobile: [479, 1],
    });
    /*----------------------------
     owl active (total-tab-product)
     ------------------------------ */
    $(".total-tab-product").owlCarousel({
        autoPlay: false,
        slideSpeed: 2000,
        pagination: false,
        navigation: true,
        items: 5,
        itemsCustom : [
            [0, 1],
            [450, 2],
            [480, 2],
            [600, 2],
            [700, 3],
            [768, 3],
            [992, 4],
            [1199, 5]
        ],
        /* transitionStyle : "fade", */
        /* [This code for animation ] */
        navigationText: false,
    });

    /*----------------------------
     owl active
     ------------------------------ */
    $(".slide-blog" ).owlCarousel({
        autoPlay: false,
        slideSpeed:2000,
        pagination:false,
        navigation:true,
        items: 3,
        itemsCustom : [
            [0, 1],
            [450, 1],
            [480, 1],
            [600, 1],
            [700, 1],
            [768, 2],
            [992, 2],
            [1199, 3]
        ],
        /* transitionStyle : "fade", */    /* [This code for animation ] */
        navigationText:["<i class='fa fa-angle-left'></i>","<i class='fa fa-angle-right'></i>"],
    });

    $(".new-arri-total").owlCarousel({
        autoPlay: false,
        slideSpeed: 2000,
        items: 1,
        pagination: false,
        navigation: true,
        navigationText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"],
        itemsDesktop: [1199, 1],
        itemsDesktopSmall: [979, 1],
        itemsTablet: [768, 1]
    });
    /*----------------------------
     scrollUp
     ------------------------------ */
    // $.scrollUp({
    //     scrollText: '<i class="fa fa-angle-up"></i>',
    //     easingType: 'linear',
    //     scrollSpeed: 900,
    //     animation: 'fade'
    // });

    /*----------------------------
     Zoom carsoule active
     ------------------------------ */
    $("#gallery_01").owlCarousel({
        autoPlay: false,
        slideSpeed: 2000,
        items: 3,
        pagination: false,
        navigation: true,
        navigationText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"],
        itemsDesktop: [1199, 3],
        itemsDesktopSmall: [979, 3],
        itemsTablet: [768, 2],
        itemsMobile: [480, 3]
    });


    /*----------------------------
     cart-plus-minus-button
     ------------------------------ */
    $(".cart-plus-minus-box").bind("paste keyup",function () {
        var newVal = $(this).val();

        if( Number(newVal)!==parseInt(newVal)){
            newVal = 1;
            $(this).val(newVal);
        }
        var s_total = newVal * 100;
        var tva = s_total * 18/100;
        $(".cart-total").find(".s_total").html( s_total+ " <em>F CFA</em>");
        $(".cart-total").find(".tva").html(tva + " <em>F CFA</em>");
        $(".cart-total").find(".total").html((s_total + tva) + " <em>F CFA</em>");
        $("#order_total_ttc").val(s_total + tva);
        $("#order_total_ht").val(s_total);
    });
    $(".cart-plus-minus")
    $(".qtybutton").on("click", function() {
        var $button = $(this);
        var oldValue = $button.parent().find("input").val();
        if ($button.text() == "+") {
            var newVal = parseFloat(oldValue) + 1;
        } else {
            // Don't allow decrementing below zero
            if (oldValue > 0) {
                var newVal = parseFloat(oldValue) - 1;
            } else {
                newVal = 0;
            }
        }
        $button.parent().find("input").val(newVal);
        var s_total = newVal * 100;
        var tva = s_total * 18/100;
        $(".cart-total").find(".s_total").html(s_total + " <em>F CFA</em>");
        $(".cart-total").find(".tva").html(tva + " <em>F CFA</em>");
        $(".cart-total").find(".total").html(s_total + tva + " <em>F CFA</em>");
        $("#order_total_ttc").val(s_total + tva);
        $("#order_total_ht").val(s_total);
        $(".cart-plus-minus-box").trigger('input');
    });

    $(".cart-plus-minus-box").bind("input",function () {
        var link = $(".link_commande").attr("href").substr(0, $(".link_commande").attr("href").indexOf('?'));
        var qte = $(".cart-plus-minus-box").val();
        var s_total = qte *100;
        var tva = s_total * 18/100;
        var total = (qte * 100) + tva;
        var new_link = link + "?qte="+qte+"&tva="+tva+"&total="+total;
        $(".link_commande").attr("href",new_link);
    });

    /*----------------------------
     fancybox active
     ------------------------------ */
    $(document).ready(function() {
        $('.fancybox').fancybox();
    });
    /*----------------------------
     Elevate Zoom active
     ------------------------------ */
    $("#zoom_03").elevateZoom({
        constrainType: "height",
        zoomType: "lens",
        containLensZoom: true,
        gallery: 'gallery_01',
        cursor: 'pointer',
        galleryActiveClass: "active"
    });

    //pass the images to Fancybox
    $("#zoom_03").bind("click", function(e) {
        var ez = $('#zoom_03').data('elevateZoom');
        $.fancybox(ez.getGalleryList());
        return false;
    });
    /*----------------------------
     menu click function
     ------------------------------ */
    $(".first").on('click', function() {
        $(this).toggleClass('clicked');
        $(".masud").slideToggle();
    });

});
