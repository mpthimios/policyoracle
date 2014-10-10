# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.toggle_show_contracts = (market_id) ->
  contracts_container = '#contracts_container' + market_id
  $(contracts_container).toggleClass('hidden')