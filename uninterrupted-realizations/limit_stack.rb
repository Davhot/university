# Ограниченный стек
class Stack
  DEF_SIZE = 7

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty; @head = 0 end

  def empty?; @head == 0 end

  def push(val)
    raise 'Stack is full' if @head >= @array.size
    @array[@head] = val; @head += 1
  end

  def pop
    raise 'Stack is empty' if @head <= 0
    @head -= 1; @array[@head]
  end

  def top
    raise 'Stack is empty' if @head <= 0
    @array[@head - 1]
  end
end
