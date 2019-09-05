require "./TkDraw"
require "./segment"
# задание окна
h = 300
w = 300
k = 10
TkDraw.create(h, w, "Example 2")
TkDraw.clean
# преобразование координат
def x(x)
  10*x + 10
end
def y(y)
  300 - 10*y - 10
end
# считывание количества водопадов
k = STDIN.gets.to_i
for i in 0 ... k
  # рисование осей
  TkDraw.line(k, 0, k, h, "black")
  TkDraw.line(0, h - k, w, h - k, "black")
  # прорисовка воды
  TkDraw.rect
  # считывание отрезков
  n = STDIN.gets.to_i

  segments = []

  for i in 0 ... n
    a = STDIN.gets.chomp.split.map{|x| x.to_i}
    x1, y1, x2, y2 = a[0], a[1], a[2], a[3]
    # прорисовка отрезков
    TkDraw.line(x(x1), y(y1), x(x2), y(y2), "black")
    segments << Segment.new(Point.new(x1, y1), Point.new(x2, y2))
  end
  # считывание точек
  n1 = STDIN.gets.to_i

  point = []

  for i in 0 ... n1
    a = STDIN.gets.chomp.split.map{|x| x.to_i}
    q1 = a[0]
    q2 = a[1]
    # прорисовка точек
    TkDraw.oval(x(q1)+2, y(q2)+2, x(q1)-2, y(q2)-2, "blue")
    point << Point.new(q1, q2)
  end

  segments.sort!.reverse!
  a = []
  # цикл по всем источникам воды(добавляются из-за источников воды на концах отрезков)
  for pi in point
    a = []
    # соотнесение отрезков и источников воды
    for si in segments
      if si.inX?(pi)
        y = si.getY(pi)
        if pi.y > y
          a << si
        end
      end
    end
    # если источник воды не падает ни на один отрезок
    if a.empty?
      TkDraw.line(x(pi.x), y(pi.y), x(pi.x), y(0), "blue")
    else
      # вода течёт по отрезку, который ближе к источнику воды
      min_s = a[0]
      for i in 1 ... a.size
        min_s = a[i] if a[i].getY(pi) > min_s.getY(pi)
      end
      # прорисовка падения воды
      TkDraw.line(x(pi.x), y(pi.y), x(pi.x), y(min_s.getY(pi)), "blue")
      # прорисовка скатывания воды по отрезку
      TkDraw.line(x(pi.x), y(min_s.getY(pi)), x(min_s.p_bottom.x), y(min_s.p_bottom.y), "blue")
      point << Point.new(min_s.p_bottom.x, min_s.p_bottom.y)
    end
  end
  sleep 5
  TkDraw.clean
end
Tk.mainloop
