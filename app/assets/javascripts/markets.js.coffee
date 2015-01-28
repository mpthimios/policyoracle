# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.toggle_show_contracts = (market_id) ->
  contracts_container = '#contracts_container' + market_id
  $(contracts_container).toggleClass('hidden')

window.update_price = (contract_id) ->
  console.log contract_id
  contract = '#contract_' + contract_id
  $('#trade_help').hide()
  $('#trade_details').hide()
  $('#trade_info').hide()
  $("#trade_not_enough_points").hide()
  $("#trade_error_enter_shares").hide()
  $('#trade_loading').show()

  utransaction = []
  utransaction["transaction_type"] = "Buy"
  quantity = $(contract).val()

  $.getJSON '/utransactions/12/simulate',{
      "utransaction[transaction_type]":"Buy",
      "utransaction[user_id]": $("#utransaction_user_id").val(),
      "utransaction[contract_id]": contract_id,
      "utransaction[quantity]": quantity
    },  (data) ->
      $('#trade_loading').hide()
      console.log data
      if (data != false)
        if (data.cash < 0)
          $("#trade_not_enough_points").show()
        else
          $('#trade_details').show()
          $('#trade_info').show()
          for k, v of data.contracts
            contract_value_container = '#current_price_' + k
            $(contract_value_container).text(v)
            console.log k + " " + v
          $("#price_per_share").text("Price per share: "+(data.cost/quantity).toFixed(2))
          $("#points_needed").text("Points needed: "+data.cost)
          $("#points_available_after").text("Points available after: "+data.cash)
          $("#shares_buying").text("You will be buying #{quantity} shares")
      else
        $("#trade_error_enter_shares").show()


