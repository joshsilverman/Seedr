$ ->
  $('.nav-tabs a').click ->
    console.log this.href.match(/#.*$/)[0]
    window.location.hash = this.href.match(/#.*$/)[0]

  if window.location.href.match(/edit#|edit$/)
    console.log(window.location.hash);
    console.log $(".nav-tabs a[href=" + window.location.hash + "]")
    console.log $(window.location.hash)

    if window.location.hash != ''
      console.log "activate hash tab"
      $(window.location.hash).addClass "active"
      $(".nav-tabs a[href=" + window.location.hash + "]").parent('li').addClass "active"
    else
      console.log "activate first tab"
      console.log tab_id = $('.tab-content .tab-pane')[0].id
      $("#" + tab_id).addClass "active"
      $(".nav-tabs a[href=#" + tab_id + "]").parent('li').addClass "active"