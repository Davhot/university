nginx_graphic = ->
  if gon.nginx_load_graph_path
    $.ajax({url: gon.nginx_load_graph_path})
  $(".nginx-form-filter-field").change ->
    if !($(this).attr("id") == "nginx_graph_form_ip" && $("#nginx_graph_form_type_ip:checked").length != 1 ||
        $(this).attr("id") == "nginx_graph_form_visitor" && $("#nginx_graph_form_type_visitor:checked").length != 1)
      send_ajax_request_for_getting_nginx_graph()
  $(".datetimepicker.nginx-form-filter-field").on 'dp.change', -> send_ajax_request_for_getting_nginx_graph()

send_ajax_request_for_getting_nginx_graph = ->
  $.ajax(
    url: gon.nginx_load_graph_path
    data: $(".nginx-form-filter").serialize()
    beforeSend: ->
      $(".nginx-form-filter .nginx-form-filter-field").attr("disabled", true)
      $(".nginx-form-filter-field").addClass("disabled")
  ).done( ->
    $(".nginx-form-filter .nginx-form-filter-field").removeAttr("disabled")
    $(".nginx-form-filter-field").removeClass("disabled")
  ).fail( ->
    alert("Данные не отправлены")
  )

$ -> nginx_graphic()
