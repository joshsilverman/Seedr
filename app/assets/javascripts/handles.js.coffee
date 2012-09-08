# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
c = (a) -> console.log a

console.log "a"
$ ->
  $(".cb").change ->

  oldselected = undefined
  console.log "b"

  draggable_helper = ->
    #drag selected items
    drag_cont = $(this).closest(".list").find('.drag_cont').clone()
    if $(this).find('input:checked').length > 0
      selected = $(this).closest(".list").find('input:checked').parents("li")
      console.log selected
      
      #drag item that is under pointer if there is no selected item 
      selected = $(this) if selected.length is 0

      drag_cont.append selected.clone()

      oldselected = selected
      console.log drag_cont
    drag_cont

  $(".list li").draggable helper: draggable_helper

  $(".listdragable").droppable
    tolerance: "pointer"
    drop: (event, ui) ->
      

      if ui.helper.children().length > 0
        # get target list name
        c this
        newList = $(this).parent().attr("id")
        
        #make dropped items in new list draggable
        $(this).append $(ui.helper.children()).clone().draggable(helper: draggable_helper)
        
        #remove dropped items from old list
        oldselected.remove()

  console.log "c"
