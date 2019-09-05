# Ограниченное множество - линейный поиск
class LSet
  DEF_SIZE = 7

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty; @size = 0 end

  def empty?; @size == 0 end
 
  def include?(val)
    !search(val).nil?
  end

  def insert(val)
    if search(val).nil?
      raise 'LSet is full' if @size >= @array.size
      @array[@size] = val; @size += 1
    end
  end

  def delete(val)
    unless (i = search(val)).nil?
      @array[i] = @array[@size - 1]; @size -= 1
    end
  end

  private
  
  def search(val)
    (0...@size).each do |i|
      return i if @array[i] == val
    end
    nil
  end
end
