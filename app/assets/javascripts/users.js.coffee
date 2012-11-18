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
  $('.poppy').live 'click', ->
    $(this).popover('show')

$ ->
  $('html').on 'click.popover.data-api', (e) ->
    if $(e.target).parents('.popover').length == 1
      return false
    else
      if $(e.target).is('.poppy')
        $(this).popover('show')
      else
        $('.poppy').popover('hide')


$ ->
  $('#item_location_name').autocomplete
    source: '/locations'

$ ->
  $.widget("custom.catcomplete", $.ui.autocomplete,
    _renderMenu: ( ul, items ) ->
      that = this
      currentCategory = ""
      for item in items
        if item.api != currentCategory
          ul.append( "<li class='ui-autocomplete-category'>" + item.api + "</li>" )
          currentCategory = item.api        
        that._renderItem( ul, item )
  )

$ ->
  $('#item_name').catcomplete
    source: '/items'
    minLength: 1
    select: ( event, ui ) -> 
      $('#item_category_name').val(ui.item.category)
      $('#item_url').val(ui.item.url)
      $('#item_api').val(ui.item.api)
      $('#item_image').val(ui.item.image)

$ ->
  $('#item_name').focus ->
    $('#item_name').catcomplete("option", "source", '/items?location=' + $('#item_location_name').val() )

