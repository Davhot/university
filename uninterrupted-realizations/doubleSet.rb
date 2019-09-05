# Ограниченное множество - двоичный поиск
class DoubleSet
  attr_reader :i
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

  def add(val)
    unless search(val)
      raise 'LSet is full' if @size >= @array.size
      ind = 0
      (@size - 1).downto(0) do |i|
        if val < @array[i]
          @array[i+1] = @array[i]
        else
          ind = i
          break
        end
      end
      ind += 1 if @size != 0 && (ind != 0 || val > @array[ind])
      @array[ind] = val
      @size += 1
    end
  end

  def delete(val)
    unless (i = search(val)).nil?
      @array[i...@size-1] = @array[i+1...@size]; @size -= 1
    end
  end

  def search(val)
    mid = @size / 2
    min = 0
    max = @size-1
    @i = 0
    if @size != 0
      Math.log2(@size).ceil.times do
        @i += 1
        return mid if val == @array[mid]
        if val > @array[mid]
          return mid + 1 if val == @array[mid + 1]
          min = mid
          mid = (min+max) / 2
        else
          return mid - 1 if val == @array[mid - 1]
          max = mid
          mid = (min+max) / 2
        end
      end
    end
    nil
  end

end
d = DoubleSet.new(20)

10.downto(0){|i| d.add(i)}
10.downto(0){|i| d.add(i)}
p d
p d.search(3)
p d.i
