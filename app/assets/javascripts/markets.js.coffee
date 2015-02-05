# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.toggle_show_contracts = (market_id) ->
  contracts_container = '#contracts_container' + market_id
  $(contracts_container).toggleClass('hidden')

ready = ->
  $('.contract-form .quantity').on 'keyup', update_price
  $('.message_button').click (e) ->
    e.preventDefault()
    tc = $(this).siblings('.transaction_container')
    was_hidden = tc.hasClass('hidden')

    $('.transaction_container').addClass('hidden')
    tc.removeClass('hidden') if was_hidden

$(document).ready(ready)
$(document).on('page:load', ready)


window.update_price = () ->
  form = $(this).parents('form')
  console.log $(this).parents('form')
  quantity = $(this).val()
  transaction_type = form.find("input:radio[name='utransaction[transaction_type]']:checked").val()
  
  $('#trade_help').hide()
  $('#trade_details').hide()
  $('#trade_info').hide()
  $("#trade_not_enough_points").hide()
  $("#trade_error_enter_shares").hide()
  $('#trade_loading').show()

  $.getJSON '/utransactions/12/simulate',form.serializeArray(),  (data) ->
      $('#trade_loading').hide()

      if (!data)
        $("#trade_error_enter_shares").show()
        return

      if (data.cash < 0)
        $("#trade_not_enough_points").show()
        return

      if (transaction_type == 'Sell' && quantity > data.current_quantity || data.current_quantity == 0)
        $("#sell_more_shares_than_holding").show()
        return

      $("#sell_more_shares_than_holding").hide()
      $('#trade_details').show()
      $('#trade_info').show()
      for k, v of data.contracts
        contract_value_container = '#current_price_' + k
        $(contract_value_container).text(v)

      $("#price_per_share").text("Average price per share: " + (100*(data.cost/quantity)).toFixed(2)/100)
      $("#points_needed").text("Points needed: " + data.cost)
      $("#points_available_after").text("Points available after: " + data.cash)
      
      if (transaction_type == 'Buy') 
        $("#shares_buying").text("You will be buying #{quantity} shares")
      else
        $("#shares_buying").text("You will be selling  #{quantity} of the #{data.current_quantity} shares you already hold")
