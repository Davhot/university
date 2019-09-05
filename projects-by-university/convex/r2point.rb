# Точка (Point) на плоскости (R2)
class R2Point 
  attr_reader :x, :y

  # конструктор
  def initialize(x = input("x"), y = input("y")) 
    @x, @y = x, y
  end

  # площадь треугольника (метод класса)
  def R2Point.area(a, b, c) 
    0.5*((a.x-c.x)*(b.y-c.y)-(a.y-c.y)*(b.x-c.x))
  end

  # лежат ли точки на одной прямой? (метод класса)
  def R2Point.triangle?(a, b, c) 
    area(a, b, c) != 0.0
  end

  # расстояние до другой точки
  def dist(other) 
    Math.sqrt((other.x-@x)**2 + (other.y-@y)**2)
  end

  # лежит ли точка внутри "стандартного" прямоугольника?
  def inside?(a, b) 
    ((a.x <= @x and @x <= b.x) or 
     (a.x >= @x and @x >= b.x)) and
      ((a.y <= @y and @y <= b.y) or 
       (a.y >= @y and @y >= b.y)) 
  end

  # освещено ли из данной точки ребро (a,b)?
  def light?(a, b) 
    s = R2Point.area(a, b, self)
    s < 0.0 or (s == 0.0 and !inside?(a, b))
  end
  
  # совпадает ли точка с другой?
  def == (other) 
    @x == other.x and @y == other.y
  end

  private
  def input(prompt)
    print "#{prompt} -> "
    readline.to_f
  end
end
