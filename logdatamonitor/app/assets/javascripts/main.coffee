@datepicker_activation = ->
  window.datepicker_activation_by_item($(document))
@datepicker_activation_by_item = (item)->
  item.find('.datetimepicker').datetimepicker({locale: 'ru', format: 'DD.MM.YYYY HH:mm'})

app_ready_f = -> window.datepicker_activation()

$ -> app_ready_f()
