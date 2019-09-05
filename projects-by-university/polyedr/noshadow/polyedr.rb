require_relative '../common/polyedr'
class Polyedr 
  def draw
    TkDrawer.clean
    edges.each{|e| TkDrawer.draw_line(e.beg, e.fin)}
  end
end
