require "tk"
class TkDraw
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
  def TkDraw.point(x, y, color)
    TkcLine.new(@@canvas, x, y, x+1, y) { fill(color) }
  end
  def TkDraw.line(x1, y1, x2, y2, color)
    TkcLine.new(@@canvas, x1, y1, x2, y2) { fill(color) }
  end
  def TkDraw.label(x, y, str, size)
    TkcText.new(@@canvas,
                @@canvas.canvasx(x),
                @@canvas.canvasy(y) ) do
      font TkFont.new(["helvetica", size, ['bold']])
      text(str)
      tags(text)
    end
  end
  def TkDraw.oval(x1, y1, x2, y2, color, w = 0)
    TkcOval.new(@@canvas, x1, y1, x2, y2) {
      fill(color)
      width(w)
    }
  end
  def TkDraw.circle(x, y, r, color)
    TkDraw.oval(x-r, y+r, x+r, y-r, color, 1)
  end
  def TkDraw.clean
    TkcRectangle.new(@@canvas, 0, 0, @@width, @@height,
                     "width"=>0) {fill("white")}
  end
end
