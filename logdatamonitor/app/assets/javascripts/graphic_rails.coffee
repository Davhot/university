rails_graphic = ->
  if gon.load_rails_graph_path
    $.ajax({url: gon.load_rails_graph_path})
  $("#rails_load_graph_form #reset-rails-graph-form").click (e)->
    $("#rails_metric_graph_form_from").val("")
    $("#rails_metric_graph_form_to").val("")
    e.preventDefault()
  $("#rails_load_graph_form .btn").last().click (e)->
    send_ajax_request_for_getting_rails_graph()
    e.preventDefault()

send_ajax_request_for_getting_rails_graph = ->
  $.ajax(
    url: gon.load_rails_graph_path
    data: $("#rails_load_graph_form").serialize()
  ).fail( ->
    alert("Данные не отправлены")
  )

$ -> rails_graphic()
