$(".slider").each(function () {
  var elem = $(this)
  var max = $(elem.attr("data-orig-table") + " tr").first().find("td").length;
  var minrange = elem.attr("data-start-n-elements");
  var value1 = 1;
  var value2 = max;
  if(max > minrange){
    value1 = max - minrange;
  } else {
    minrange = max - 1;
  }
  if($(".ui-slider-range", this).length) {
    elem.dragslider("destroy")
  }
  elem.dragslider({
    range: true,
    min: 1,
    max: max,
    minRangeSize: minrange,
    maxRangeSize: +minrange + 2,
    values: [ value1, value2],
    rangeDrag: true,
    create: function( event, ui ) {
      $(this).prev().find(".amount").attr('value', value1 + " - " + (value2 - 1)  + " (" + (max - 1) + ")"  );
        // Показываем значения
        cur_val = value1
        cur_tr_show = $($(this).attr("data-show-table") + " tr")
        cur_tr_orig = $($(this).attr("data-orig-table") + " tr")
        for (var i = 1; i <= cur_tr_show.length; i++) {
          cur_tr_show.eq(i - 1).find("td").each(function(index, elem) {
            $(elem).text(cur_tr_orig.eq(i - 1).find("td").eq(cur_val + index - 1).text())
          })
        }
        for (var i = 1; i <= cur_tr_show.length; i++) {
          cur_tr_show.eq(i - 1).find("td").first()
            .text(cur_tr_orig.eq(i - 1).find("td").eq(0).text())
        }
    },
    slide: function( event, ui ) {
      cur_tr_show = $($(this).attr("data-show-table") + " tr")
      cur_tr_orig = $($(this).attr("data-orig-table") + " tr")
      $(this).prev().find(".amount").val( "$" + $( ".slider-range" ).slider( "values", 0 ) +
        " - $" + $( ".slider-range" ).slider( "values", 1 ) + " (" + (max - 1) + ")" );
      // Изменяем кол-во столбцов
      if (+(ui.values[ 1 ] - ui.values[ 0 ]) != +cur_tr_show.eq(0).find("td").length - 1) {
        val =  (ui.values[ 1 ] - ui.values[ 0 ] + 1) - cur_tr_show.eq(0).find("td").length
        if (val > 0) {
          cur_tr_show.each(function () {
            for (i = 0; i < val; i ++) {
              $(this).append("<td></td>")
            }
          })
          // alert("NEED ADD " + val + " COLUMNS")
        } else if (val < 0) {
          cur_tr_show.each(function (index, elem) {
            for (i = 0; i < val * (-1); i ++) {
              $(this).find("td").eq(0).remove()
            }
          })
          // alert("NEED REMOVE " + (val * (-1)) + " COLUMNS")
        }
      }
      // Показываем значения
      cur_val = ui.values[ 0 ]
      for (var i = 1; i <= cur_tr_show.length; i++) {
        cur_tr_show.eq(i - 1).find("td").each(function(index, elem) {
          $(elem).text(cur_tr_orig.eq(i - 1).find("td").eq(cur_val + index - 1).text())
        })
      }
      for (var i = 1; i <= cur_tr_show.length; i++) {
        cur_tr_show.eq(i - 1).find("td").first()
          .text(cur_tr_orig.eq(i - 1).find("td").eq(0).text())
      }

      $(this).prev().find(".amount").val( ui.values[ 0 ] + " - " + (ui.values[ 1 ] - 1)
         + " (" + (max - 1) + ")" );
    }
  });
});
