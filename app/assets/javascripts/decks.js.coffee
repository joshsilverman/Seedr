
$ ->

  ##########
  ## sort ##
  ##########
  $('.card').draggable()
  $('.group').droppable
    drop: (event, ui) -> 
        dragged = $(ui.draggable[0])
        cards = $(this).children ".cards"
        group = $(this)
        group_id = group.attr "group_id"
        dragged.css({position:''}).appendTo(cards)

        $.get '/cards/' + dragged.attr('card_id') + '/group/' + (if (group_id != '') then group_id else 0),
          (response) -> group.attr('group_id', response)

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

  $('.best_in_place').best_in_place()

  $(".group h3, .ungrouped_cards h3").click ->
    cards = $(this).next('.cards')
    if cards.hasClass "active"
      cards.slideUp "slow", ->
        $(this).closest('.group, .ungrouped_cards').animate height: 40
    else
      $(this).closest('.group, .ungrouped_cards').css {height: ''}#, ->
      cards.slideDown "slow"
    cards.toggleClass "active"

  ##########
  ## tabs ##
  ##########
  $('.nav-tabs a').click ->
    $.get window.location.href, (a) ->
      console.log a

  $('.ungroup_link').click ->
    card_id = $(this).closest('tr').attr('card_id')
    card = $(this).closest('tr')
    $.get '/cards/' + card_id + '/ungroup',
      'success': -> card.slideUp()

