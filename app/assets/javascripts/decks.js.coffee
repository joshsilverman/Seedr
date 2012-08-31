
$ ->
  $('.card').draggable()
  $('.group').droppable
    drop: (event, ui) -> 
        dragged = $(ui.draggable[0])
        cont = $(this).children ".cards"
        group_id = cont.parent('.group').attr "group_id"

        dragged.css({position:''}).appendTo(this)

        $.get '/cards/' + dragged.attr('card_id') + '/group/' + (if (group_id != '') then group_id else 0),
          (response) -> cont.attr('group_id', response)

  window.make_droppable = (elmnt) ->
    elmnt.droppable
      drop: (event, ui) -> 
          dragged = $(ui.draggable[0])
          cont = $(this).children ".cards"

          dragged.css({left:0, top:0}).appendTo($('.ungrouped_cards'))

          $.get '/cards/' + dragged.attr('card_id') + '/ungroup'

  make_droppable $('.ungrouped_cards')

  $sidebar = $(".ungrouped_cards_cont")
  $window = $(window)
  offset = $sidebar.offset()
  topPadding = 60

  #$window.scroll ->
  #  if $window.scrollTop() > offset.top - topPadding
  #    $sidebar.css position: 'fixed', top: topPadding
  #    $sidebar.children('.cards').css height:$window.height() - topPadding - 20, overflowY:'scroll'
  #    $('.groups').addClass 'offset6'
  #  else
  #    $sidebar.css position: '', top: 0, height:'', overflow:''
  #    $('.groups').removeClass 'offset6'

  #$('#add_group').click ->
  #  new_group = $('#sample_group').children().clone()
  #  $('.add_group').before new_group
  #  make_droppable new_group

  $('.best_in_place').best_in_place()

  #$(".accordion H2:first").addClass "active"
  #$(".accordion p:not(:first)").hide()
  $(".group h3 span, .ungrouped_cards h3 span").click ->
    cards = $(this).parent('h3').next('.cards')
    if cards.hasClass "active"
      cards.slideUp "slow", ->
        $(this).parent('.group, .ungrouped_cards').animate height: 20
    else
      $(this).parent().parent('.group, .ungrouped_cards').css {height: ''}#, ->
      cards.slideDown "slow"

    cards.toggleClass "active"


