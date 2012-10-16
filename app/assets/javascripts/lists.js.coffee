# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#location-toggle').click (event) ->
    event.preventDefault()
    $(this).hide()
    $('.field#location').show()

$ ->
  $('.container').on 'click', '.itemModalButton', ->
    event.preventDefault()
    itemModalButtonID = $(this).attr 'id'
    list_id = itemModalButtonID.slice(21)
    $('#itemModal').modal('show')
    $('.field#location').hide()
    $('#location-toggle').show()
    $('input#item_name').val("")
    $('input#item_name').focus()
    $('#itemModalLabel').text('Add Item to ' + $('#listTitle-list_'+list_id).text())
    $('#item_list_id').val(list_id)
