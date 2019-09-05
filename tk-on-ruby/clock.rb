require './tkdraw.rb'
include Math
require 'time'
WIDTH = 700
HEIGHT = 700
K = 10
r = 10
def x(x)
  (K*x + WIDTH/2).round
end
def y(y)
  (WIDTH/2 - K*y).round
end
def polar(phi, r, x1 = 0, y1 = 0)
  phi = PI/180*phi
  x = r * cos(phi) + x1
  y = r * sin(phi) + y1
  [x(x), y(y)]
end
def draw_axis
  TkDraw.line(0, HEIGHT/2, WIDTH, HEIGHT/2, "black")
  TkDraw.line(WIDTH/2, 0, WIDTH/2, HEIGHT, "black")
  for i in -WIDTH/(2*K)+1 ... WIDTH/(2*K)-1
    TkDraw.label(x(i), HEIGHT/2+K, i, 10) if i % 5 == 0 && i != 0
    TkDraw.label(WIDTH/2 - K, y(i), i, 10) if i % 5 == 0 && i != 0
  end
end
TkDraw.create(WIDTH, HEIGHT, "CLOCK")
TkDraw.clean
# draw_axis
while true
  t = Time.now
  TkDraw.oval(x(-r), y(-r), x(r), y(r), "white", 2)
  a = polar(90-t.sec*6, r)
  b = polar(90-t.min*6, r-3)
  c = polar(90-t.hour*6, r-5)
  TkDraw.line(a[0], a[1],x(0), y(0), "black")
  TkDraw.line(b[0], b[1],x(0), y(0), "black")
  TkDraw.line(c[0], c[1],x(0), y(0), "black")
  s = t.strftime("%H:%M:%S")
  TkDraw.label(x(-K), y(-K), s, 10)
  sleep 1
  TkDraw.clean
end
# Tk.mainloop
