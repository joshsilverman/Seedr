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

class Decks

  ##########
  ## sort ##
  ##########
  draggable_helper: ->
    drag_cont = $(this).closest(".list").find('.drag_cont').clone().appendTo "body"
    if $(this).hasClass "ui-selected"
      selected = $(".list").find('li.ui-selected')
      selected = $(this) if selected.length is 0
      drag_cont.append selected.clone(true)
      sort.oldselected = selected

    $('.list').each (i, list) ->
      list = $(list)
      list.addClass "drag-in-progress"
      cards = list.find('ul')

      # sort.offset = $(window).scrollTop(150)
      # $(window).scrollTop(0)

    drag_cont

  draggable_stop: =>
    setTimeout =>
        $('.list').each (i, list) ->
          list = $(list)
          list.removeClass "drag-in-progress"
          $(window).scrollTop(sort.offset)

        @after_drop()
      1000

  droppable_drop: (event, ui) ->
    if ui.helper.children().length > 0
      
      list = $(this).identify()
      ul = list.find('ul')
      cards = ui.helper.children('li').clone()

      ul.append cards
      sort.oldselected.remove()
      cards.removeClass('ui-selected').removeClass('drag-in-progress')

      group = list
      group_id = group.attr "group_id"
      card_ids = cards.map((i,c) -> $(c).attr('card_id')).toArray().join()

      if group_id == "-1"
        $.get('/cards/' + card_ids + '/ungroup').complete => @after_drop(group)
      else
        $.get('/cards/' + card_ids + '/group/' + (if (group_id != '') then group_id else 0),
            (response) => 
              if (group.find('h3 .btn').length == 0)
                group = $("#" + group.attr('id'))

                group_id = response
                group.attr('group_id', group_id)
                h3 = group.find('h3').identify()
                name_span = h3.find("span > span")
                question_format = h3.find(".question_format")
                answer_format = h3.find(".answer_format")
                btn_toolbar = $('#sample_toolbar .btn-toolbar').clone()

                name_span.attr
                  'id': "best_in_place_group_" + group_id + "_name"
                  'data-url': "/groups/" + group_id
                  'data-activator': ".list[group_id=" + group_id + "] .rename"
                  'data-object': "group"
                  'data-attribute': "name"
                  'data-type': "input"
                  'class': "best_in_place"

                question_format.attr
                  'id': "best_in_place_group_" + group_id + "_question_format"
                  'data-url': "/groups/" + group_id
                answer_format.attr
                  'id': "best_in_place_group_" + group_id + "_answer_format"
                  'data-url': "/groups/" + group_id

                edit = btn_toolbar.find('.edit').attr 'href', '/groups/' + group_id + '/edit'
                destroy = btn_toolbar.find('.destroy').attr 
                  'href': '/groups/' + group_id
                  'data-confirm': "Are you sure?"
                  'data-method': "delete"
                  'rel': "nofollow"

                group.find('.btn-toolbar').replaceWith btn_toolbar
                name_span.best_in_place()
                group.removeClass "new"
                group.addClass "recently-activated"
                group.find('.rename').click (e) -> e.stopPropagation()

                new_group = $('#sample_list .list').clone()
                group.after new_group

          ).complete => 
            decks.after_drop(group)

            group = $('.recently-activated')
            group.find('.rename').trigger 'click' 
            group.removeClass 'recently-activated'

  after_drop: (group) =>
    $('.list').each (i, l) -> 
      l = $(l)
      lc = l.clone()
      if group and l[0] == group[0]
        group = lc

      l.replaceWith(lc)

    @init_sort()

  init_sort: ->
    window.sort = {}
    sort.oldselected = undefined

    $('.list ul').selectable()

    $(".list li").draggable 
      helper: @draggable_helper
      handle: 'i'
      stop: @draggable_stop

    $(".list").droppable
      tolerance: "pointer"
      drop: @droppable_drop
      hoverClass: "drop-hover"

    $('.best_in_place').each (i, elmnt) -> $(elmnt).best_in_place()
    $('.btn-toolbar, .formats').click (e) -> e.stopPropagation()
    $('.formats .best_in_place').keyup (e) -> decks.previewQuestions(e)
    $('.best_in_place').bind("ajax:success", => $('.preview').hide());

    $(".list h3").click ->
      list = $(this).closest('.list')
      cards = list.find('ul')
      if list.hasClass "active"
        # cards.slideUp "slow", ->
        #   list.animate height: 40
      else
        deactivated = $('.list.active')
        deactivated.removeClass "active"

        deactivated.find('h3').effect "highlight"
        list.find('h3').effect "highlight"

        list.css {height: ''}#, ->
        cards.slideDown "slow"

        list.toggleClass "active"

    # lists = $(".list")
    # lists_wrapper = $(".list").closest '.row'
    # lists.get().sort (a, b) ->
    #   c $($(a).find('h3 span')[0]).text()
    #   c $($(b).find('h3 span')[0]).text()
    #   $($(a).find('h3 span')[0]).text().localeCompare($($(b).find('h3 span')[0]).text())
    # c lists
    # $.each(lists, (idx, itm) -> lists_wrapper.append(itm))

  previewQuestions: (e) ->
    input = $(e.target)
    list = input.closest('.list')
    window.list = list

    question_format = list.find('input[name=question_format]')[0].value if list.find('input[name=question_format]')[0]
    question_format ||= list.find('span[data-attribute=question_format]')[0].innerHTML
    answer_format = list.find('input[name=answer_format]')[0].value if list.find('input[name=answer_format]')[0]
    answer_format ||= list.find('span[data-attribute=answer_format]')[0].innerHTML

    list.find('.preview').show()

    group_id = list.attr "group_id"

    $.post "/groups/#{group_id}/preview", 
        question_format: question_format,
        answer_format: answer_format
      , (r, status) ->
        $.each r, (k,v) ->
          # c status
          # v = {question:'error', answer:''} unless status == '200'

          card = $("li[card_id=#{k}]")
          question_wrapper = card.find(".question")
          answer_wrapper = card.find(".answer")
          question_wrapper.html v.question
          answer_wrapper.html v.answer

$ ->
  window.decks = new Decks
  decks.init_sort()
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

