# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.toggle_show_contracts = (market_id) ->
  contracts_container = '#contracts_container' + market_id
  $(contracts_container).toggleClass('hidden')

$(document).on 'click', '.edit_task input[type=checkbox]', ->
  $(this).parent('form').submit()

# alternatively:

ready = ->
  $(document).on 'click', '.edit_task input[type=checkbox]', ->
    $(this).parent('form').submit()

$(document).ready(ready)
$(document).on('page:load', ready)