# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#listModal').on 'shown', (event) ->
    $('#list_title').val("")
    $('#list_title').focus()

$ ->
  $("[rel=tooltip]").tooltip()

$ ->
  $("[rel=popover]").popover({placement:'bottom', trigger:'manual'}).click ->
        $(this).popover('toggle')

$ ->
  $('.poppy').live 'click', ->
    $(this).popover('toggle')

$ ->
  $('#item_location_name').autocomplete
    source: '/locations'

$ ->
  $('#item_name').autocomplete
    source: '/items'
    select: ( event, ui ) -> $('#item_category_name').val(ui.item.label)

$ ->
  $('#item_name').focus ->
    $('#item_name').autocomplete("option", "source", '/items?location=' + $('#item_location_name').val() )


