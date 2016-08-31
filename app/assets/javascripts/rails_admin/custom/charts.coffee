(($) ->
  class @Charts
    constructor: (context,type,data,options) ->
      @context = context
      @type = type
      @data = data
      @options = options
      @chart =  new Chart(@context, {
        type:  @type,
        data: @data,
        options: @options
      })
) jQuery