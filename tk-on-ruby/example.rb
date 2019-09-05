require './tkdraw.rb'
w = 600
h = 600
TkDraw.create(w, h)
TkDraw.clean
color = ["white", "yellow", "green", "red", "cyan", "black", "blue", "orange"]
while true
  TkDraw.oval(rand(1..w), rand(1..h), rand(1..w), rand(1..h), color[rand(0...color.size)], 1)
  sleep 0.1
end
Tk.mainloop
