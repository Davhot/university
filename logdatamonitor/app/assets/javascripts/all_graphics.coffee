all_graphs = ->
  if gon.all_graphs_path
    $.ajax({url: gon.all_graphs_path})
  $("#load_all_graphs_form #reset-rails-graph-form").click (e)->
    $("#all_graphs_from").val("")
    $("#all_graphs_to").val("")
    e.preventDefault()
  $("#load_all_graphs_form .btn").last().click (e)->
    send_ajax_request_for_getting_all_graphs()
    e.preventDefault()

send_ajax_request_for_getting_all_graphs = ->
  $.ajax(
    url: gon.all_graphs_path
    data: $("#load_all_graphs_form").serialize()
  ).fail( ->
    alert("Данные не отправлены")
  )

$ -> all_graphs()
