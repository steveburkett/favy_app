# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#submit_item').click (event) ->
    event.preventDefault()
    $('input#item_name').catcomplete('close');
    if $('input#item_name').val()
      $('#new_item').submit()
    $('#itemModal').modal('hide');

$ ->
  $('#itemModal').on 'shown', ->
    $('input#item_name').focus()
    $('input#item_name').val("")
    $('input#item_location_name').val("")
    $('input#item_category_name').val("")
    $('input#item_initial_comment').val("")
    $('input#item_url').val("")
    $('input#item_wishlist').prop('checked', false)
    itemPreview = document.getElementById("itemPreview")
    itemPreview.innerHTML = ""

$ ->
  $('#itemModal').on 'hide', ->
    $('input#item_name').focus()
    $('input#item_name').val("")
    $('input#item_location_name').val("")
    $('input#item_category_name').val("")
    $('input#item_initial_comment').val("")
    $('input#item_url').val("")
    $('input#item_wishlist').prop('checked', false)
    itemPreview = document.getElementById("itemPreview")
    itemPreview.innerHTML = ""


$ ->
  $('#submit_item_another').click (event) ->
    event.preventDefault()
    if $('input#item_name').val()
      $('#new_item').submit()


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
    $('#location-toggle').show()
    $('input#item_name').val("")
    $('input#item_name').focus()
    $('#itemModalLabel').text('Add Item to ' + $('#listTitle-list_'+list_id).text())
    $('#item_list_id').val(list_id)

$ ->
  $('.container').on 'click', '#listModalButton', ->
    event.preventDefault()
    $('#listModal').modal('show')
    $('input#list_title').val("")
    $('input#list_title').focus()
    $('input#list_tag_list').val("")

$ ->
  $('.privacy').change ->
    $(this).closest("form").submit()