class Queue
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

  private
  def forward(index)
    index == @array.size - 1 ? 0 : index + 1
  end
end
