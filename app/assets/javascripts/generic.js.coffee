$ ->

  #preload correct tab
  $('.nav-tabs a').click ->
    hash = this.href.match(/#[^?]*$|#.*(?=\?)/)[0]
    window.location.hash = this.href.match(/#[^?]*$|#.*\?/)[0]
    #console.log this.href.match(/#.*$/)[0]

  if window.location.href.match(/edit[#?]|edit$/)
    console.log(window.location.hash);
    hash_exp = /#[^?]*$|#.*(?=\?)/
    if window.location.hash.match(hash_exp)
      hash = window.location.hash.match(hash_exp)[0]
    else
      hash = false

    console.log(hash);

    if hash != false
      $(hash).addClass "active"
      $(".nav-tabs a[href=" + hash + "]").parent('li').addClass "active"
    else
      tab_id = $('.tab-content .tab-pane')[0].id
      $("#" + tab_id).addClass "active"
      $(".nav-tabs a[href=#" + tab_id + "]").parent('li').addClass "active"