ready = ->
  $(".growl-msg").each ->
    type=$(this).data('type') || 'info'
    if type == 'danger'
      $.growl $(this).html(),
        type: type
        delay: 0
    else
      $.growl $(this).html(),
        type: type

$ -> ready()
