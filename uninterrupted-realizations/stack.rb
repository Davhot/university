class Stack
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
end
