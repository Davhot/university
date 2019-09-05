server_table = ->
  if gon.server_main_staticstic_path
    $.ajax({url: gon.server_main_staticstic_path})
  $("#get_ajax_table_main_metric").find("button").click (e) ->
    $.ajax({url: gon.server_main_staticstic_path, data: $("#get_ajax_table_main_metric").serialize()})
    e.preventDefault()
  $("#reset-main-metric-table-form").click (e) ->
    $("#main_metric_table_form_from").val("")
    $("#main_metric_table_form_to").val("")
    e.preventDefault()

network_table =->
  if gon.server_network_staticstic_path
    $.ajax({url: gon.server_network_staticstic_path})
  $("#get_ajax_table_network_metric").find("button").click (e) ->
    $.ajax({url: gon.server_network_staticstic_path, data: $("#get_ajax_table_network_metric").serialize()})
    e.preventDefault()
  $("#reset-network-metric-table-form").click (e) ->
    $("#network_metric_table_form_from").val("")
    $("#network_metric_table_form_to").val("")
    e.preventDefault()

$ ->
  server_table()
  network_table()
