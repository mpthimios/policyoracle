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
  $('#trade_details').show()
  $('#trade_info').show()
  utransaction = []
  utransaction["transaction_type"] = "Buy"
  quantity = $(contract).val()

  $.getJSON '/utransactions/12/simulate',{
      "utransaction[transaction_type]":"Buy",
      "utransaction[user_id]": $("#utransaction_user_id").val(),
      "utransaction[contract_id]": contract_id,
      "utransaction[quantity]": quantity
    },  (data) ->
      console.log data
      for k, v of data.contracts
        contract_value_container = '#current_price_' + k
        $(contract_value_container).text(v+"%")
        console.log k + " " + v
      $("#points_needed").text("Points needed: "+data.cost)
      $("#points_available_after").text("Points available after: "+data.cash)
      $("#shares_buying").text("You will be buying #{quantity} shares")


