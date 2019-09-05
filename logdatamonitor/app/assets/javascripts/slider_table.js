// Возможность передвигать весь range
(function( $, undefined ) {
  $.widget("ui.dragslider", $.ui.slider, {

      options: $.extend({},$.ui.slider.prototype.options,{rangeDrag:false}),

      _create: function() {
        $.ui.slider.prototype._create.apply(this,arguments);
        this._rangeCapture = false;
      },

      _mouseCapture: function( event ) {
        var o = this.options;

        if ( o.disabled ) return false;

        if(event.target == this.range.get(0) && o.rangeDrag == true && o.range == true) {
          this._rangeCapture = true;
          this._rangeStart = null;
        }
        else {
          this._rangeCapture = false;
        }

        $.ui.slider.prototype._mouseCapture.apply(this,arguments);

        if(this._rangeCapture == true) {
            this.handles.removeClass("ui-state-active").blur();
        }

        return true;
      },

      _mouseStop: function( event ) {
        this._rangeStart = null;
        return $.ui.slider.prototype._mouseStop.apply(this,arguments);
      },

      _slide: function( event, index, newVal ) {
        if(!this._rangeCapture) {
          return $.ui.slider.prototype._slide.apply(this,arguments);
        }

        if(this._rangeStart == null) {
          this._rangeStart = newVal;
        }

        var oldValLeft = this.options.values[0],
            oldValRight = this.options.values[1],
            slideDist = newVal - this._rangeStart,
            newValueLeft = oldValLeft + slideDist,
            newValueRight = oldValRight + slideDist,
            allowed;

        if ( this.options.values && this.options.values.length ) {
          if(newValueRight > this._valueMax() && slideDist > 0) {
            slideDist -= (newValueRight-this._valueMax());
            newValueLeft = oldValLeft + slideDist;
            newValueRight = oldValRight + slideDist;
          }

          if(newValueLeft < this._valueMin()) {
            slideDist += (this._valueMin()-newValueLeft);
            newValueLeft = oldValLeft + slideDist;
            newValueRight = oldValRight + slideDist;
          }

          if ( slideDist != 0 ) {
            newValues = this.values();
            newValues[ 0 ] = newValueLeft;
            newValues[ 1 ] = newValueRight;

            // A slide can be canceled by returning false from the slide callback
            allowed = this._trigger( "slide", event, {
              handle: this.handles[ index ],
              value: slideDist,
              values: newValues
            } );

            if ( allowed !== false ) {
              this.values( 0, newValueLeft, true );
              this.values( 1, newValueRight, true );
            }
            this._rangeStart = newVal;
          }
        }



      },
  });
})(jQuery);

// Минимальный, максимальный доступные промежутки
(function ($) {
    if ($.ui.dragslider)
    {
        // add minimum range length option
        $.extend($.ui.slider.prototype.options, {
            minRangeSize: 0,
            maxRangeSize: 100,
            autoShift: false,
            lowMax: 100,
            topMin: 0
        });

        $.extend($.ui.slider.prototype, {
            _slide: function (event, index, newVal) {
                var otherVal,
                newValues,
                allowed,
                factor;

                if (this.options.values && this.options.values.length)
                {
                    otherVal = this.values(index ? 0 : 1);
                    factor = index === 0 ? 1 : -1;

                    if (this.options.values.length === 2 && this.options.range === true)
                    {
                        // lower bound max
                        if (index === 0 && newVal > this.options.lowMax)
                        {
                            newVal = this.options.lowMax;
                        }
                        // upper bound min
                        if (index === 1 && newVal < this.options.topMin)
                        {
                            newVal = this.options.topMin;
                        }
                        // minimum range requirements
                        if ((otherVal - newVal) * factor < this.options.minRangeSize)
                        {
                            newVal = otherVal - this.options.minRangeSize * factor;
                        }
                        // maximum range requirements
                        if ((otherVal - newVal) * factor > this.options.maxRangeSize)
                        {
                            if (this.options.autoShift === true)
                            {
                                otherVal = newVal + this.options.maxRangeSize * factor;
                            }
                            else
                            {
                                newVal = otherVal - this.options.maxRangeSize * factor;
                            }
                        }
                    }

                    if (newVal !== this.values(index))
                    {
                        newValues = this.values();
                        newValues[index] = newVal;
                        newValues[index ? 0 : 1] = otherVal;
                        // A slide can be canceled by returning false from the slide callback
                        allowed = this._trigger("slide", event, {
                            handle: this.handles[index],
                            value: newVal,
                            values: newValues
                        });
                        if (allowed !== false)
                        {
                            this.values(index, newVal, true);
                            this.values((index + 1) % 2, otherVal, true);
                        }
                    }
                } else
                {
                    if (newVal !== this.value())
                    {
                        // A slide can be canceled by returning false from the slide callback
                        allowed = this._trigger("slide", event, {
                            handle: this.handles[index],
                            value: newVal
                        });
                        if (allowed !== false)
                        {
                            this.value(newVal);
                        }
                    }
                }
            }
        });
    }
})(jQuery);

// $(document).ready(function () {
//   $(".slider").each(function () {
//     var elem = $(this)
//     var max = $(elem.attr("data-orig-table") + " tr").first().find("td").length;
//     var minrange = elem.attr("data-start-n-elements");
//     var value1 = 1;
//     var value2 = max;
//     if(max > minrange){
//       value1 = max - minrange;
//     } else {
//       minrange = max - 1;
//     }
//     elem.dragslider({
//       range: true,
//       min: 1,
//       max: max,
//       minRangeSize: minrange,
//       maxRangeSize: +minrange + 2,
//       values: [ value1, value2],
//       rangeDrag: true,
//       create: function( event, ui ) {
//         $(this).prev().find(".amount").val( value1 + " - " + (value2 - 1)  + " (" + (max - 1) + ")"  );
//           // Показываем значения
//           cur_val = value1
//           cur_tr_show = $($(this).attr("data-show-table") + " tr")
//           cur_tr_orig = $($(this).attr("data-orig-table") + " tr")
//           for (var i = 1; i <= cur_tr_show.length; i++) {
//             cur_tr_show.eq(i - 1).find("td").each(function(index, elem) {
//               $(elem).text(cur_tr_orig.eq(i - 1).find("td").eq(cur_val + index - 1).text())
//             })
//           }
//           for (var i = 1; i <= cur_tr_show.length; i++) {
//             cur_tr_show.eq(i - 1).find("td").first()
//               .text(cur_tr_orig.eq(i - 1).find("td").eq(0).text())
//           }
//       },
//       slide: function( event, ui ) {
//         cur_tr_show = $($(this).attr("data-show-table") + " tr")
//         cur_tr_orig = $($(this).attr("data-orig-table") + " tr")
//         $(this).prev().find(".amount").val( "$" + $( ".slider-range" ).slider( "values", 0 ) +
//           " - $" + $( ".slider-range" ).slider( "values", 1 ) + " (" + (max - 1) + ")" );
//         // Изменяем кол-во столбцов
//         if (+(ui.values[ 1 ] - ui.values[ 0 ]) != +cur_tr_show.eq(0).find("td").length - 1) {
//           val =  (ui.values[ 1 ] - ui.values[ 0 ] + 1) - cur_tr_show.eq(0).find("td").length
//           if (val > 0) {
//             cur_tr_show.each(function () {
//               for (i = 0; i < val; i ++) {
//                 $(this).append("<td></td>")
//               }
//             })
//             // alert("NEED ADD " + val + " COLUMNS")
//           } else if (val < 0) {
//             cur_tr_show.each(function (index, elem) {
//               for (i = 0; i < val * (-1); i ++) {
//                 $(this).find("td").eq(0).remove()
//               }
//             })
//             // alert("NEED REMOVE " + (val * (-1)) + " COLUMNS")
//           }
//         }
//         // Показываем значения
//         cur_val = ui.values[ 0 ]
//         for (var i = 1; i <= cur_tr_show.length; i++) {
//           cur_tr_show.eq(i - 1).find("td").each(function(index, elem) {
//             $(elem).text(cur_tr_orig.eq(i - 1).find("td").eq(cur_val + index - 1).text())
//           })
//         }
//         for (var i = 1; i <= cur_tr_show.length; i++) {
//           cur_tr_show.eq(i - 1).find("td").first()
//             .text(cur_tr_orig.eq(i - 1).find("td").eq(0).text())
//         }
//
//         $(this).prev().find(".amount").val( ui.values[ 0 ] + " - " + (ui.values[ 1 ] - 1)
//            + " (" + (max - 1) + ")" );
//       }
//     });
//   });
//
// });
