class Segment
  # начало и конец отрезка (числа)
  attr_reader :beg, :end
  def initialize(b, e)
    @beg, @end = b, e
  end
  # отрезок вырожден?
  def degenerate? 
    @beg >= @end
  end
  # пересечение с отрезком
  def intersect!(other) 
    @beg = other.beg if other.beg > @beg
    @end = other.end if other.end < @end
    self
  end
  # разность отрезков
  def subtraction(other)
    [Segment.new(@beg, @end < other.beg ? @end : other.beg),
     Segment.new(@beg > other.end ? @beg : other.end, @end)]
  end
end
