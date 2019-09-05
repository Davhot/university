require 'tk'

module TkDrawer
  # запуск интерпретатора графического интерфейса
  def TkDrawer.create
    CANVAS.pack{padx 5; pady 5}; Thread.new{Tk.mainloop}
  end
  # стирание 
  def TkDrawer.clean 
    TkcRectangle.new(CANVAS, 0, 0, SIZE, SIZE, 'width'=>0) {fill('white')}
  end
  # рисование линии
  def TkDrawer.draw_line(p,q)
    TkcLine.new(CANVAS, x(p), y(p), x(q), y(q)) {fill('black')}    
  end

  private
  # преобразование координат
  def TkDrawer.x(p)
    SIZE/2 + SCALE*p.x
  end
  def TkDrawer.y(p)
    SIZE/2 - SCALE*p.y
  end
  # Размер окна и коэффициент гомотетии
  SIZE   = 600; SCALE  = 1
  # Корневое окно графического интерфейса
  ROOT   = TkRoot.new{title 'Polyedr'; geometry "#{SIZE+5}x#{SIZE+5}"}
  # Окно для рисования
  CANVAS = TkCanvas.new(ROOT, 'height'=>SIZE, 'width'=>SIZE)
end
