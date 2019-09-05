#encoding: UTF-8
require "./TkDraw"

class Point
  include Comparable
  attr_reader :x, :y
  def initialize(x = get('x'), y = get('y'))
    @x, @y = x.to_f, y.to_f
  end

  def ==(b)
    b.x == @x && b.y == @y
  end

  def to_s
    "(#{x};#{y})"
  end

  def dist(other)
    Math.sqrt((other.x-@x)**2 + (other.y-@y)**2)
  end

  def get(ch)
    print "Ввидите #{ch}: "
    gets.to_i
  end
end

class Segment
  attr_reader :p_top, :p_bottom
  def initialize(a, b)
    raise "Не точка" if a.class != Point || b.class != Point
    a, b = b, a if a.y < b.y
    @p_top, @p_bottom = a, b
  end

  def to_s
    "Отрезок: #{@p_top}<---->#{@p_bottom}"
  end

  def perimeter
    dist * 2
  end

  def ==(s)
    s.p_top == @p_top && s.p_bottom == @p_bottom
  end

  def dist
    ((@p_top.x - @p_bottom.x)**2 + (@p_top.y-@p_bottom.y)**2)**(1/2.0)
  end

  def area(a, b, c)
    0.5*((a.x-c.x)*(b.y-c.y)-(a.y-c.y)*(b.x-c.x))
  end
  # дистанция от отрезка до нуля
  def distance_to_null
    zero = Point.new(0,0)
    p1 = @p_bottom
    p2 = @p_top
    ao = p1.dist(zero)
    bo = p2.dist(zero)
    ab = p1.dist(p2)
    cosA = (ao**2+ab**2-bo**2) / (2*ao*ab)
    cosB = (bo**2+ab**2-ao**2) / (2*bo*ab)
    h = nil
    if (0..1).include?(cosA) && (0..1).include?(cosB)
      h = 2.0*area(p1, p2, zero).abs/ab
    end
    a = [ao, bo]
    a << h if h != nil
    r = a.min
  end

  def <=>(s)
    distance_to_null <=> s.distance_to_null
  end

  def inX?(p)
     @p_top.x <= p.x && p.x <= @p_bottom.x || @p_top.x >= p.x && p.x >= @p_bottom.x
  end
  # получение y-координаты точки, полученной пересечением отрезка и прямой || оси oy из точки p
  def getY(p) #получено из уравнения прямых
    if @p_top.x <= p.x && p.x <= @p_bottom.x || @p_top.x >= p.x && p.x >= @p_bottom.x
      x1, x2, x3, x4 = @p_top.x, @p_bottom.x, p.x, p.x
      y1, y2, y3, y4 = @p_top.y, @p_bottom.y, p.y, 0
      x = ((y3-y1)*(x2-x1)*(x4-x3)+x1*(y2-y1)*(x4-x3)-x3*(y4-y3)*(x2-x1))/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
      y = (x-x1)*(y2-y1)/(x2-x1)+y1
      y
    end
  end
  # пересекаются ли два отрезка
  def intersect?(s)
    raise "Не отрезок" if s.class != Segment
    return true if s.p_top == @p_top || s.p_bottom == @p_bottom
    x1, x2, x3, x4 = @p_top.x, @p_bottom.x, s.p_top.x, s.p_bottom.x
    y1, y2, y3, y4 = @p_top.y, @p_bottom.y, s.p_top.y, s.p_bottom.y
    v1 = (x4-x3)*(y1-y3)-(y4-y3)*(x1-x3)
    v2 = (x4-x3)*(y2-y3)-(y4-y3)*(x2-x3)
    v3 = (x2-x1)*(y3-y1)-(y2-y1)*(x3-x1)
    v4 = (x2-x1)*(y4-y1)-(y2-y1)*(x4-x1)
    (v1*v2 < 0) && (v3*v4 < 0)
  end
  # получение пустого множества, точки или отрезка путём пересечения двух отрезков
  def self.intersect(s1, s2)
    if s1 == s2
      return s1
    elsif s1.intersect?(s2)
      x1, x2, x3, x4 = s1.p_top.x, s1.p_bottom.x, s2.p_top.x, s2.p_bottom.x
      y1, y2, y3, y4 = s1.p_top.y, s1.p_bottom.y, s2.p_top.y, s2.p_bottom.y
      x = ((y3-y1)*(x2-x1)*(x4-x3)+x1*(y2-y1)*(x4-x3)-x3*(y4-y3)*(x2-x1))/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
      y = (x-x1)*(y2-y1)/(x2-x1)+y1
      p1 = Point.new(x, y)
      if s1.p_top == s2.p_top
        return(Segment.new(s1.p_top, p1))
      elsif s1.p_bottom == s2.p_bottom
        return(Segment.new(s1.p_bottom, p1))
      else
        return Point.new(x, y)
      end
    end
    nil
  end

  # получение пустого множества, точки или отрезка путём пересечения двух отрезков
  def intersect(s)
    if self == s
      return s
    elsif intersect?(s)
      x1, x2, x3, x4 = @p_top.x, @p_bottom.x, s.p_top.x, s.p_bottom.x
      y1, y2, y3, y4 = @p_top.y, @p_bottom.y, s.p_top.y, s.p_bottom.y
      x = ((y3-y1)*(x2-x1)*(x4-x3)+x1*(y2-y1)*(x4-x3)-x3*(y4-y3)*(x2-x1))/((y2-y1)*(x4-x3)-(y4-y3)*(x2-x1))
      y = (x-x1)*(y2-y1)/(x2-x1)+y1
      p1 = Point.new(x, y)
      if @p_top == s.p_top
        return(Segment.new(@p_top, p1))
      elsif @p_bottom == s.p_bottom
        return(Segment.new(@p_bottom, p1))
      else
        return Point.new(x, y)
      end
    end
    nil
  end
end
################################################################################
if $0 == __FILE__
  p1 = Point.new(0.0, 0.0)
  p2 = Point.new(2,2)
  p3 = Point.new(0,2)
  p4 = Point.new(2,0)
  p5 = Point.new(4,2)
  segment1 = Segment.new(p1, p2)
  segment2 = Segment.new(p4, p3)
  segment3 = Segment.new(p3, p5)
  puts segment1.intersect(segment2)
  puts segment1.intersect(segment3)
end
