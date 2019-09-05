network_graphic = ->
  if gon.network_load_graph_path
    $.ajax({url: gon.network_load_graph_path})
  $("#network_load_graph_form #reset-network-metric-graph-form").click (e)->
    $("#network_metric_graph_form_from").val("")
    $("#network_metric_graph_form_to").val("")
    e.preventDefault()
  $("#network_load_graph_form .btn").last().click (e)->
    send_ajax_request_for_getting_network_graph()
    e.preventDefault()

send_ajax_request_for_getting_network_graph = ->
  $.ajax(
    url: gon.network_load_graph_path
    data: $("#network_load_graph_form").serialize()
    beforeSend: ->
      $(".network-form-filter .network-form-filter-field").attr("disabled", true)
      $(".network-form-filter-field").addClass("disabled")
  ).done( ->
    $(".network-form-filter .network-form-filter-field").removeAttr("disabled")
    $(".network-form-filter-field").removeClass("disabled")
  ).fail( ->
    alert("Данные не отправлены")
  )



main_metric_graphic = ->
  if gon.main_metric_load_graph_path
    $.ajax({url: gon.main_metric_load_graph_path})
  $("#main_metric_load_graph_form #reset-main_metric-metric-graph-form").click (e)->
    $("#main_metric_metric_graph_form_from").val("")
    $("#main_metric_metric_graph_form_to").val("")
    e.preventDefault()
  $("#main_metric_load_graph_form .btn").last().click (e)->
    send_ajax_request_for_getting_main_metric_graph()
    e.preventDefault()

send_ajax_request_for_getting_main_metric_graph = ->
  $.ajax(
    url: gon.main_metric_load_graph_path
    data: $("#main_metric_load_graph_form").serialize()
    beforeSend: ->
      $(".main_metric-form-filter .main_metric-form-filter-field").attr("disabled", true)
      $(".main_metric-form-filter-field").addClass("disabled")
  ).done( ->
    $(".main_metric-form-filter .main_metric-form-filter-field").removeAttr("disabled")
    $(".main_metric-form-filter-field").removeClass("disabled")
  ).fail( ->
    alert("Данные не отправлены")
  )

$ ->
  network_graphic()
  main_metric_graphic()
