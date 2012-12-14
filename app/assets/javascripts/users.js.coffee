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
  $('.img_remove').live 'click', ->
    document.getElementById('imgPreview').style.visibility='hidden'
    $('.img_remove').hide()
    $('#item_image').val('')


$ ->
  $('html').on 'click.popover.data-api', (e) ->
    if $(e.target).parents('.popover').length == 1
      if $(e.target).is('#wishlist') or $(e.target).is('.btn')
        return true
      else
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
        if item.category != currentCategory
          if $('#item_location_name').val().length == 0
            ul.append( "<li class='ui-autocomplete-category'>" + item.category + "&nbsp;&nbsp;<img src='http://library.corporate-ir.net/library/17/176/176060/mediaitems/93/a.com_logo_th.jpg' height='60' width='60' style='margin-top:-4px'>" + "</li>" )
          else
            ul.append( "<li class='ui-autocomplete-category'>" + item.category + "&nbsp;&nbsp;<img src='http://s3-media1.ak.yelpcdn.com/assets/2/www/img/14f29ad24935/map/miniMapLogo.png' style='margin-top:-4px'>" + "</li>" )
          currentCategory = item.category        
        that._renderItem( ul, item )
  )

$ ->
  $('#item_name').catcomplete(
    source: '/items'
    delay: 400
    minLength: 0
    select: ( event, ui ) -> 
      console.log("selected")
      $('#item_category_name').val(ui.item.category)
      $('#item_url').val(ui.item.api_url)
      $('#item_api').val(ui.item.api)
      $('#item_image').val(ui.item.image)
      img = document.createElement("img");
      img.src = ui.item.image
      $('imgPreview').show()
      imgPreview = document.getElementById("imgPreview")      
      imgPreview.src = img.src
      imgPreview.className = "img-polaroid"
      imgPreview.style.visibility='visible'
    search: ->
      $("#search_placeholder").hide()
      $("#search_message").show()
    open: ->
      $("#search_message").hide()
      $("#search_placeholder").show()
    ).data("catcomplete")._renderItem = (ul, item) ->
      $( "<li style='display:block'></li>" ).data( "item.autocomplete", item ).append( "<a><div class='list_item_container'><div class='item_image'><img src='" + item.image + "'></div><div class='item_label'>" + item.label + "</div><div class='item_description'>" + item.details + "</div></div></a>" ).appendTo( ul )

$ ->
  $('#item_name').focus ->
    $('#item_name').catcomplete("option", "source", '/items?location=' + $('#item_location_name').val() )

$ ->
  $('#imgPreview').live
    mouseenter: () -> $('.img_remove').show()


