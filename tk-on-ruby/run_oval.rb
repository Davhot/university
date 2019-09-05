require './tkdraw.rb'
w = 600
h = 600
TkDraw.create(w, h)
TkDraw.clean
color = ["white", "yellow", "green", "red", "cyan", "black", "blue", "orange"]
i = 0
x_c = 6
y_c = 6
r = 5
STEP = 10
while true
  TkDraw.circle(x_c, y_c, r, color[rand(0 ... color.size)])
  TkDraw.circle(w - x_c, w - y_c, r, color[rand(0 ... color.size)])
  TkDraw.circle(w, w - y_c, r, color[rand(0 ... color.size)])
  TkDraw.circle(w - x_c, w, r, color[rand(0 ... color.size)])
  TkDraw.circle(w, y_c, r, color[rand(0 ... color.size)])
  TkDraw.circle(x_c, w, r, color[rand(0 ... color.size)])
  x_c += STEP
  y_c += STEP
  r += 1
  sleep 0.1
  TkDraw.clean
end
Tk.mainloop
