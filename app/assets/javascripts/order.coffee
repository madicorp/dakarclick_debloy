(($)->
  $(document).on 'ready page:change',(event)  ->
    $('.btn-radio').click (e) ->
      $('.btn-radio').not(this).removeClass('active').siblings('input').removeAttr('checked',false).siblings('.img-radio').css('opacity','0.5').css('border','none')
      $(this).addClass('active').siblings('input').attr('checked','true').siblings('.img-radio').css('opacity','1').css('border', '1px solid #1253a4')
      if $(this).siblings('input').attr('id') == 'card-item'
        $(".card-info-block").show()
      else
        $(".card-info-block").hide()

    card = $('.card-info').card {
      container : '.card-wrapper',
      formSelectors: {
        numberInput: 'input[name="card[number]"]',
        nameInput: 'input[name="card[firstname]"], input[name="card[lastname]"]',
        expiryInput: 'input[name="card[month]"], input[name="card[year]"]',
        cvcInput: 'input[name="card[cvc]"]'
      },
      placeholders: {
        number: '•••• •••• •••• ••••',
        name: 'Nom et Prenom',
        expiry: '••/••',
        cvc: '•••'
      },
      messages: {
        validDate: 'valid\ndate',
        monthYear: 'mm/yyyy',
      },
      debug: true
    }
    # add this.$card.attr('data-card-type',cardType); to line 788 of card plugin provide card type
    $('input[name="card[number]"]').keyup ->
      type = $('.card-container .card').attr('data-card-type')
      if type != "unknown"
        $('input[name="card[type]"').val type
      else
        $('input[name="card[type]"').val ""
) jQuery