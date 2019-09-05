# Два стека, ограниченные в совокупности
class DblStack
  DEF_SIZE = 7

  def initialize(size = DEF_SIZE)
    @array = Array.new(size)
    empty
  end

  def empty(stack = nil)
    case stack
    when nil
      @head0 = @head1 = 0
    when 0
      @head0 = 0
    when 1
      @head1 = 0
    else
      raise 'Wrong stack'
    end
  end

  def empty?(stack = nil)
    case stack
    when nil
      @head0 == 0 and @head1 == 0
    when 0
      @head0 == 0
    when 1
      @head1 == 0
    else
      raise 'Wrong stack'
    end
  end

  def push(stack, val)
    raise 'Stacks are full' if @head0 + @head1 >= @array.size
    case stack
    when 0
      @array[@head0] = val; @head0 += 1
    when 1
      @array[@array.size - @head1 - 1] = val; @head1 += 1
    else
      raise 'Wrong stack'
    end
  end

  def pop(stack)
    case stack
    when 0
      raise 'Stack is empty' if @head0 <= 0
      @head0 -= 1; @array[@head0]
    when 1
      raise 'Stack is empty' if @head1 <= 0
      @head1 -= 1; @array[@array.size - @head1 - 1]
    else
      raise 'Wrong stack'
    end
  end

  def top(stack)
    case stack
    when 0
      raise 'Stack is empty' if @head0 <= 0
      @array[@head0 - 1]
    when 1
      raise 'Stack is empty' if @head1 <= 0
      @array[@array.size - @head1]
    else
      raise 'Wrong stack'
    end
  end

  def del(elem)
    s = search(elem)
    if s[0] != nil
      @array.delete_at(s[0])
      s[1] == 0 ? @head0 -= 1 : @head1 -= 1
    end
  end

  # возвращает индекс первого найденного элемента и стек
  def search(elem, stack = nil)
    case stack
    when nil
      s1 = @array[0..@head0].index(elem) # поиск по первому стреку
      s2 = @array[-@head1..(@array.size-1)].index(elem) # поиск по второму стреку
      s1 != nil ? [s1, 0] : [s2, 1]
    when 0
      [@array[0..@head0].index(elem), 0]
    when 1
      [@array[-@head1..(@array.size-1)].index(elem), 1]
    end
  end
end

d = DblStack.new(20)
for i in 0 .. 10
  d.push(i%2, i)
end
p d
d.del(2)
p d
