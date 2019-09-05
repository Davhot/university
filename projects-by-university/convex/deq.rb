# Реализация дека на основе Array в Ruby 
# (эта реализация тривиальна)
class Deq
  def initialize
    @array = Array.new
  end
  
  def size
    @array.size
  end

  def push_last(c)
    @array.push(c)
  end

  def push_first(c)
    @array.unshift(c)
  end

  def pop_last
    @array.pop
  end
  
  def pop_first 
    @array.shift
  end
  
  def last
    @array.last
  end

  def first
    @array.first
  end
end
