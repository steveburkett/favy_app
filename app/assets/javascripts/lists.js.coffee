# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.location-toggle').click (event) ->
    event.preventDefault()
    $(this).hide()
    $('.field#location').show()

$ ->
  $('.itemmodal').on 'shown', (event) ->
    $('.field#location').hide()
    $('.location-toggle').show()
    $('input#item_name').val("")
    $('input#item_name').focus()