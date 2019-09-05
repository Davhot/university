require 'tk'
class TkDraw
  # инициализация окна
  def TkDraw.create(h = 200, w = 200, name = "Tk")
    @@height, @@width = h, w
    @@root = TkRoot.new{
      title name
      geometry "#{w}x#{h}"
    }
    @@canvas = TkCanvas.new(@@root,
                            "height" => h,
                            "width" => w)
    @@canvas.pack{ padx 5; pady 5 }
    Thread.new{Tk.mainloop}
    TkcRectangle.new(@@canvas, 0, 0, h, w,
                     "width"=>0) { fill("white") }
  end
  # рисование точки
  def TkDraw.point(x, y, color)
    TkcLine.new(@@canvas, x, y, x+1, y) { fill(color) }
  end
  # рисование линии
  def TkDraw.line(x1, y1, x2, y2, color)
    TkcLine.new(@@canvas, x1, y1, x2, y2) { fill(color) }
  end
  # рисование текста
  def TkDraw.label(x, y, str, size)
    TkcText.new(@@canvas,
                @@canvas.canvasx(x),
                @@canvas.canvasy(y) ) do
      font TkFont.new(["helvetica", size, ['bold']])
      text(str)
      tags(text)
    end
  end
  # прорисовка овала
  def TkDraw.oval(x1, y1, x2, y2, color, w = 0)
    TkcOval.new(@@canvas, x1, y1, x2, y2) {
      fill(color)
      width(w)
    }
  end
  # вода
  def TkDraw.rect
    TkDraw.clean(0, @@height - 10, @@width, @@height, "blue")
  end
  # очистка экрана
  def TkDraw.clean(x1 = 0, y1 = 0, x2 = @@width, y2 = @@height, color = "white")
    TkcRectangle.new(@@canvas, x1, y1, x2, y2,
                     "width"=>0) {fill(color)}
  end
end
