# Ограниченная очередь
class Queue
  DEF_SIZE = 7

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty; @size = @head = 0; @tail = @array.size - 1 end

  def empty?; @size == 0 end

  def enqueue(val)
    raise 'Queue is full' if @size >= @array.size
    @size += 1
    @tail = forward(@tail)
    @array[@tail] = val
  end

  def dequeue
    raise 'Queue is empty' if @size <= 0
    val = @array[@head]
    @size -= 1
    @head = forward(@head)
    val
  end

  def front
    raise 'Queue is empty' if @size <= 0
    @array[@head]
  end

  private

  def forward(index)
    index == @array.size - 1 ? 0 : index + 1
  end
end
