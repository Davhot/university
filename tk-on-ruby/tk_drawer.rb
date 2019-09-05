require "tk"
# Графический интерфейс выпуклой оболочки (модуль)
module TkDrawer
  # запуск интерпретатора графического интерфейса
  def TkDrawer.create
    CANVAS.pack{padx 5; pady 5}; Thread.new{Tk.mainloop}
  end
  # "стирание" картинки и рисование осей координат
  def TkDrawer.clean
    TkcRectangle.new(CANVAS, 0, 0, SIZE, SIZE, "width"=>0) {fill("white")}
    TkcLine.new(CANVAS, 0, SIZE/2, SIZE, SIZE/2) {fill("blue")}
    TkcLine.new(CANVAS, SIZE/2, 0, SIZE/2, SIZE) {fill("blue")}
  end
  # рисование точки
  def TkDrawer.draw_point(p)
    TkcOval.new(CANVAS, x(p) + 1, y(p) + 1, x(p) - 1, y(p) - 1) {fill("black")}
  end
  # рисование окружности
  def TkDrawer.draw_circle(p, r, color = "red")
    TkcOval.new(CANVAS, x1(p.x-r), y1(p.y+r), x1(p.x+r), y1(p.y-r)) {fill(color)}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q)
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill("black")}
  end
  # добавление текста
  def TkDrawer.label(x, y, str, size)
    TkcText.new(CANVAS, x, y) do
      font TkFont.new(["helvetica", size, ['bold']])
      text(str)
      tags(text)
    end
  end

  private
  # преобразование координат(аргумент точка)
  def TkDrawer.x(p)
    SIZE/2 + SCALE*p.x
  end
  def TkDrawer.y(p)
    SIZE/2 - SCALE*p.y
  end
  # преобразование координат(аргумент координата)
  def TkDrawer.x1(x)
    SIZE/2 + SCALE*x
  end
  def TkDrawer.y1(y)
    SIZE/2 - SCALE*y
  end
  # Размер окна и коэффициент гомотетии
  SIZE   = 600; SCALE  = 50
  # Корневое окно графического интерфейса
  ROOT   = TkRoot.new{title "Convex"; geometry "#{SIZE+5}x#{SIZE+5}"}
  # Окно для рисования
  CANVAS = TkCanvas.new(ROOT, "height"=>SIZE, "width"=>SIZE)
end

# Точка (Point) на плоскости (R2)
class R2Point
  attr_reader :x, :y

  # конструктор
  def initialize(x = input("x"), y = input("y"))
    @x, @y = x, y
  end

  private
  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
end

if __FILE__ == $0
  p = R2Point.new(0,0)
  TkDrawer.create
  TkDrawer.clean
  TkDrawer.draw_circle(p, 4, "white")
  Tk.mainloop
end
