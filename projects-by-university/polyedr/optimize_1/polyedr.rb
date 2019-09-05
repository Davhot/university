require_relative  '../common/polyedr'

# Одномерный отрезок
class Segment
  # начало и конец отрезка (числа)
  attr_reader :beg, :fin
  def initialize(b, f)
    @beg, @fin = b, f
  end
  # отрезок вырожден?
  def degenerate? 
    @beg >= @fin
  end
  # пересечение с отрезком
  def intersect!(other) 
    @beg = other.beg if other.beg > @beg
    @fin = other.fin if other.fin < @fin
    self
  end
  # разность отрезков
  def subtraction(other)
    [Segment.new(@beg, @fin < other.beg ? @fin : other.beg),
     Segment.new(@beg > other.fin ? @beg : other.fin, @fin)]
  end
end

# Ребро полиэдра
class Edge 
  # Начало и конец стандартного одномерного отрезка
  SBEG = 0.0; SFIN = 1.0
  # начало и конец ребра (точки в R3), список "просветов"
  attr_reader :beg, :fin, :gaps
  def initialize(b, f)
    @beg, @fin, @gaps = b, f, [Segment.new(SBEG, SFIN)]
  end  
  # учёт тени от одной грани
  def shadow(facet)
    return if facet.vertical?
    # нахождение одномерной тени на ребре
    shade = Segment.new(SBEG, SFIN)
    facet.vertexes.zip(facet.v_normals) do |arr|
     shade.intersect!(intersect_edge_with_normal(arr[0], arr[1]))
      return if shade.degenerate? 
    end
    shade.intersect!(intersect_edge_with_normal(facet.vertexes[0], facet.h_normal))
    return if shade.degenerate?    
    # преобразование списка "просветов", если тень невырождена
    @gaps = @gaps.map do |s|
      s.subtraction(shade)
    end.flatten.delete_if(&:degenerate?)
  end
  # преобразование одномерных координат в трёхмерные
  def r3(t)
    @beg*(SFIN-t) + @fin*t
  end

  private
  # пересечение ребра с полупространством, задаваемым точкой (a)
  # на плоскости и вектором внешней нормали (n) к ней
  def intersect_edge_with_normal(a, n)
    f0, f1 = n.dot(@beg - a), n.dot(@fin - a)
    return Segment.new(SFIN, SBEG) if f0 >= 0.0 and f1 >= 0.0
    return Segment.new(SBEG, SFIN) if f0 < 0.0 and f1 < 0.0
    x = - f0 / (f1 - f0)
    f0 < 0.0 ? Segment.new(SBEG, x) : Segment.new(x, SFIN)
  end
end    

# Грань полиэдра
class Facet 
  # "вертикальна" ли грань?
  def vertical?
    h_normal.dot(Polyedr::V) == 0.0
  end
  # нормаль к "горизонтальному" полупространству
  def h_normal
    n = (@vertexes[1]-@vertexes[0]).cross(@vertexes[2]-@vertexes[0])
    n.dot(Polyedr::V) < 0.0 ? n*(-1.0) : n
  end
  # нормали к "вертикальным" полупространствам, причём k-я из них
  # является нормалью к гране, которая содержит ребро, соединяющее
  # вершины с индексами k-1 и k
  def v_normals
    (0...@vertexes.size).map do |k|
      n = (@vertexes[k] - @vertexes[k-1]).cross(Polyedr::V)
      n.dot(@vertexes[k-1] - center) < 0.0 ? n*(-1.0) : n
    end
  end

  private
  # центр грани
  def center
    @vertexes.inject(R3.new(0.0,0.0,0.0)){|s,v| s+v}*(1.0/@vertexes.size)
  end
end

# Полиэдр
class Polyedr 
  # вектор проектирования
  V = R3.new(0.0,0.0,1.0)

  # удаление дубликатов рёбер
  def edges_uniq
    edges = []
    @edges.each do |e|
      include = false
      edges.each do |d|
        if d.beg == e.beg && d.fin == e.fin ||
          d.beg == e.fin && d.fin == e.beg
          include = true
          break
        end
      end
      edges << e unless include
    end
    @edges = edges
  end

  # оптимизация
  def optimize
    puts   '   Удаление дубликатов рёбер'
    stage_time = Time.now
    printf "     Рёбер до    : %6d\n", @edges.size
    edges_uniq
    printf "     Рёбер после : %6d\n", @edges.size
    printf "     Время       : %9.2f сек.\n", Time.now - stage_time
    self
  end

  def shadow
    edges.each do |e|
      facets.each{|f| e.shadow(f)}
    end
  end

  def draw
    TkDrawer.clean
    edges.each do |e|
      e.gaps.each{|s| TkDrawer.draw_line(e.r3(s.beg), e.r3(s.fin))}
    end
  end
end
