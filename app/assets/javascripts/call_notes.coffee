# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

show_section = (condition, section) ->
  if condition
    $(section).show()
  else
    $(section).hide()
  return

$(document).ready ->
  $('form :input').click ->
    call_answer = $('input[name=\'call_note[call_answer]\']:checked').val() == 'spoke_to'
    show_section call_answer, '#call_notes_name'