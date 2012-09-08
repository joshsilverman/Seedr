
$ ->

  ##########
  ## sort ##
  ##########
  $('.cards').selectable()
  $('.card').draggable(
      handle: "span"
      helper: ->
        
        #drag selected items
        selected = $(".ui-selected")
        console.log selected
        
        #drag item that is under pointer if there is no selected item
        selected = $(this)  if selected.length is 0
        container = $("<div/>").attr("id", "draggingContainer")
        container.append selected.clone()
        oldselected = selected
        container)

  $('.group').droppable
    drop: (event, ui) -> 
        dragged = $(ui.draggable[0])
        cards = $(this).children ".cards"
        group = $(this)
        group_id = group.attr "group_id"
        dragged.css({position:''}).appendTo(cards)

        # get target list name
        new_list = $(this).parent().attr("id")
        console.log new_list
        
        return
        #make dropped items in new list draggable
        $(this).append $(ui.helper.children()).clone().draggable(helper: ->
          selected = $("#" + newList + " input:checked").parents("li")
          selected = $(this)  if selected.length is 0
          container = $("<div/>").attr("id", "draggingContainer")
          container.append selected.clone()
          oldselected = selected
          container
        )
        oldselected.remove()

        dragged = $(ui.draggable[0])
        cont = $(this).children ".cards"

        dragged.css({left:0, top:0}).appendTo($('.ungrouped_cards'))

        #$.get '/cards/' + dragged.attr('card_id') + '/ungroup'

        ############
        return
        $.get '/cards/' + dragged.attr('card_id') + '/group/' + (if (group_id != '') then group_id else 0),
          (response) -> 
            if (group.find('h3 .btn').length == 0)
              group_id = response
              group.attr('group_id', group_id)
              h3 = group.find('h3')
              name_span = h3.find("span span")
              console.log name_span
              btn_toolbar = $('#sample_toolbar .btn-toolbar').clone()

              rename = btn_toolbar.find('.rename')
              name_span.attr
                'id': "best_in_place_group_" + group_id + "_name"
                'data-url': "/groups/" + group_id
                'data-activator': ".group[group_id=" + group_id + "] .rename"
                'data-object': "group"
                'data-attribute': "name"
                'data-type': "input"

              edit = btn_toolbar.find('.edit').attr 'href', '/groups/' + group_id + '/edit'
              destroy = btn_toolbar.find('.destroy').attr 
                'href': '/groups/' + group_id
                'data-confirm': "Are you sure?"
                'data-method': "delete"
                'rel': "nofollow"

              btn_toolbar.appendTo h3
              name_span.best_in_place()

              new_group = $('#sample_group .well').clone()
              group.after new_group
























































  #window.make_droppable = (elmnt) -> elmnt.droppable
  #make_droppable $('.ungrouped_cards')

  $sidebar = $(".ungrouped_cards_cont")
  $window = $(window)
  offset = $sidebar.offset()
  topPadding = 60

  $('.best_in_place').each (i, elmnt) -> 
    console.log $(elmnt)
    $(elmnt).best_in_place()

  $(".group h3 span, .ungrouped_cards h3 span").click ->
    cards = $(this).parent('h3').next('.cards')
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

