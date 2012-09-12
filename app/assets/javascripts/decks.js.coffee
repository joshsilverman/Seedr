c = (o) -> console.log o
jQuery.fn.identify = ->
  i = 0
  @each ->
    return if $(this).attr("id")
    loop
      i++
      id = "guid_" + i
      break unless $("#" + id).length > 0
    $(this).attr "id", id

$ ->

  ##########
  ## sort ##
  ##########
  draggable_helper = ->
    drag_cont = $(this).closest(".list").find('.drag_cont').clone().appendTo "body"
    if $(this).hasClass "ui-selected"
      selected = $(".list").find('.ui-selected')
      selected = $(this) if selected.length is 0
      drag_cont.append selected.clone(true)
      sort.oldselected = selected

    $('.list').each (i, list) ->
      list = $(list)
      list.addClass "drag-in-progress"
      cards = list.find('ul')

      sort.offset = $(window).scrollTop(150)
      $(window).scrollTop(0)

    drag_cont

  draggable_stop = ->
    setTimeout ->
        $('.list').each (i, list) ->
          list = $(list)
          list.removeClass "drag-in-progress"
          $(window).scrollTop(sort.offset)

        after_drop()
      1000

  droppable_drop = (event, ui) ->
    if ui.helper.children().length > 0
      
      list = $(this).identify()
      ul = list.find('ul')
      cards = ui.helper.children('li').clone()

      ul.append cards
      sort.oldselected.remove()

      group = list
      group_id = group.attr "group_id"
      card_ids = cards.map((i,c) -> $(c).attr('card_id')).toArray().join()

      if group_id == "-1"
        $.get('/cards/' + card_ids + '/ungroup').complete -> after_drop(group)
      else
        $.get('/cards/' + card_ids + '/group/' + (if (group_id != '') then group_id else 0),
            (response) -> 
              c response
              c group.find('h3 .btn')
              if (group.find('h3 .btn').length == 0)
                group = $("#" + group.attr('id'))

                group_id = response
                group.attr('group_id', group_id)

                c group


                h3 = group.find('h3').identify()

                c 'h3'
                c h3

                name_span = h3.find("span span")

                c 'name span'
                c name_span

                btn_toolbar = $('#sample_toolbar .btn-toolbar').clone()

                c 'btn toolbar'
                c btn_toolbar

                rename = btn_toolbar.find('.rename')

                c 'rename'
                c rename

                name_span.attr
                  'id': "best_in_place_group_" + group_id + "_name"
                  'data-url': "/groups/" + group_id
                  'data-activator': ".list[group_id=" + group_id + "] .rename"
                  'data-object': "group"
                  'data-attribute': "name"
                  'data-type': "input"
                  'class': "best_in_place"

                edit = btn_toolbar.find('.edit').attr 'href', '/groups/' + group_id + '/edit'
                destroy = btn_toolbar.find('.destroy').attr 
                  'href': '/groups/' + group_id
                  'data-confirm': "Are you sure?"
                  'data-method': "delete"
                  'rel': "nofollow"

                btn_toolbar.appendTo h3
                name_span.best_in_place()

                new_group = $('#sample_list .list').clone()
                group.after new_group
          ).complete -> #after_drop(group)

  after_drop = (group) ->
    $('.list').each (i, l) -> 
      l = $(l)
      lc = l.clone()
      if group and l[0] == group[0]
        group = lc

      l.replaceWith(lc)

    init_sort()

  init_sort = ->
    window.sort = {}
    sort.oldselected = undefined

    $('.list ul').selectable()

    $(".list li").draggable 
      helper: draggable_helper
      handle: 'i'
      stop: draggable_stop

    $(".list").droppable
      tolerance: "pointer"
      drop: droppable_drop
      hoverClass: "drop-hover"

    $('.best_in_place').each (i, elmnt) -> $(elmnt).best_in_place()

    $(".list h3 i").click ->
      list = $(this).closest('.list')
      cards = list.find('ul')
      if list.hasClass "active"
        cards.slideUp "slow", ->
          list.animate height: 40
      else
        list.css {height: ''}#, ->
        cards.slideDown "slow"
      list.toggleClass "active"

  init_sort()
  $('body').click -> $('.ui-selected').removeClass "ui-selected"






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

