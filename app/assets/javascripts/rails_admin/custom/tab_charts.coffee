(($) ->
  $(document).on('pjax:success', ->
    chartVta = null
    chartCa = null
    chartNtcu = null
    chartNtcup = null
## Init Date Piker
    $(".date-filter").each ->
      piker = $(this).find(".date")
      $(piker).datetimepicker({format: 'MMMM YYYY'})

## Init Date Piker for Range Date
    $(".range-date-filter").each ->
      start_piker = $(this).find(".start-date")
      end_piker = $(this).find(".end-date")
      $(start_piker).datetimepicker({defaultDate: moment().subtract(1,'d'),format: 'D MMMM YYYY'})
      $(end_piker).datetimepicker({useCurrent: false, defaultDate: moment(),format: 'D MMMM YYYY' })
      $(end_piker).data("DateTimePicker").minDate(moment())
      $(start_piker).data("DateTimePicker").maxDate(moment().subtract(1,'d'))
      $(start_piker).on(
        "dp.change",
        (e) ->
          $(end_piker).data("DateTimePicker").minDate(moment(e.date).add(1,'d'))
      )
      $(end_piker).on(
        "dp.change",
        (e) ->
          $(start_piker).data("DateTimePicker").maxDate(moment(e.date).subtract(1,'d'))
      )

    $(".chart-nav").click (e) ->
      e.preventDefault()
      href = $(this).attr("href")
      switch href
        when "#vta"
          totalValueChart()
        when "#ca"
          $("#ca").find("form").submit(
            (e) ->
              e.preventDefault()
              form = $(this).serializeArray()
              begins_at = moment(form[0].value).format('DD-MM-YYYY')
              ends_at = moment(form[1].value).format('DD-MM-YYYY')
              chiffreDaffaireChart(begins_at, ends_at)
              return false;
          )
          $("#ca").find("form").submit()
        when "#ntcu"
          $("#ntcu").find("form").submit(
            (e) ->
              e.preventDefault()
              form = $(this).serializeArray()
              begins_at = moment(form[0].value).format('DD-MM-YYYY')
              ends_at = moment(form[1].value).format('DD-MM-YYYY')
              coinUtiliserChart(begins_at, ends_at)
              return false;
          )
          $("#ntcu").find("form").submit()
        when "#ntcup"
          coinUtiliserProduitChart()
      $(this).tab('show')
      return false;

## Charts functions
    totalValueChart = ->
      if chartVta
        chartVta.destroy
      $.post("",{'stats' : 'total_value'}).done(
        (resp) ->
          ctx = $("#vta-canvas")
          type = 'polarArea'
          console.log resp
          totalValueChartData = {
            labels: ["Valeur Total des Arcticles", "Valeur totale des prix affichés"],
            datasets: [{
              data : [resp.total_price, resp.total_value],
              backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(153, 102, 255, 0.2)',
              ],
              borderColor: [
                'rgba(255,99,132,1)',
                'rgba(153, 102, 255, 1)',
              ],
              borderWidth: 1
            }]
          }
          chartVta = new Charts(ctx,type,totalValueChartData,null)
      )

    chiffreDaffaireChart = (begins_at,ends_at) ->
      if chartCa
        chartCa.destroy
      $.post("",{'stats' : 'cash_flow', 'begins_at' : begins_at, 'ends_at' : ends_at}).done(
        (resp) ->
          ctx = $("#ca-canvas")
          type = 'line'
          labels = []
          data = []
          labels = Object.keys(resp.cash_flow).sort((date1, date2) ->
            return moment(date1, "YYYY-MM-DD").diff(moment(date2, "YYYY-MM-DD"))
          )

          sortedValues = labels.map((key) ->
            return resp.cash_flow[key]
          )

          data = sortedValues.reduce(
            (data, current, idx) ->
              data.push((data[data.length - 1] || 0) + Number(current))
              return data
          , []
          )

          cashflowChartData = {
            labels: labels,
            datasets: [{
              label : "Chiffre D'affaire",
              data: data,
              backgroundColor: 'rgba(54, 162, 235, 0.2)',
              borderColor: 'rgba(54, 162, 235, 1)',
              borderWidth: 1,
              fill: false,
              lineTension: 0.1,
              pointBorderColor: "rgba(75,192,192,1)",
              pointBackgroundColor: "#fff",
              pointBorderWidth: 1,
              pointHoverRadius: 5,
              pointHoverBackgroundColor: "rgba(75,192,192,1)",
              pointHoverBorderColor: "rgba(220,220,220,1)",
              pointHoverBorderWidth: 2,
              pointRadius: 1,
              pointHitRadius: 10,
            }]
          }
          chartCa = new Charts(ctx,type,cashflowChartData,null)
      )

    coinUtiliserChart = (begins_at,ends_at) ->
      if chartNtcu
        chartNtcu.destroy
      $.post("",{'stats' : 'used_coin', 'begins_at' : begins_at, 'ends_at' : ends_at}).done(
        (resp) ->
          ctx = $("#ntcu-canvas")
          type = 'line'

          labels = Object.keys(resp.used_coin)
          data = Object.keys(resp.used_coin)


          coinUtiliserChartData = {
            labels: labels,
            datasets: [{
              label : "Coins Utilisés",
              data: data,
              backgroundColor: 'rgba(54, 162, 235, 0.2)',
              borderColor: 'rgba(54, 162, 235, 1)',
              borderWidth: 1,
              fill: false,
              lineTension: 0.1,
              pointBorderColor: "rgba(75,192,192,1)",
              pointBackgroundColor: "#fff",
              pointBorderWidth: 1,
              pointHoverRadius: 5,
              pointHoverBackgroundColor: "rgba(75,192,192,1)",
              pointHoverBorderColor: "rgba(220,220,220,1)",
              pointHoverBorderWidth: 2,
              pointRadius: 1,
              pointHitRadius: 10,
            }]
          }
          chartNtcu = new Charts(ctx,type,coinUtiliserChartData,null)
      )

    coinUtiliserProduitChart = ->
      if chartNtcup
        chartNtcup.destroy
      $.post("",{'stats' : 'used_coin_product'}).done(
        (resp) ->
          console.log resp
          ctx = $("#ntcup-canvas")
          type = 'polarArea'
          labels = []
          data = []
          $.each(resp, (k,v) ->
            labels.push(k)
            data.push(v)
          )
          console.log labels
          console.log data

          coinUtiliserProduitChartData = {
            labels: labels,
            datasets: [{
              data : data,
              backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
              ],
              borderColor: [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
              ],
              borderWidth: 1
            }]
          }
          chartNtcup = new Charts(ctx,type,coinUtiliserProduitChartData,null)
      )
    Object.values = (object) ->
      values = []
      for property in object
        values.push(object[property])

      return values
  )
) jQuery ,Charts