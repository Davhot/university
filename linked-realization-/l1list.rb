class L1Node
  attr_accessor :key, :next

  def initialize(k, n = nil)
    @key, @next = k, n
  end

  def to_s
    "[#{@key}|#{@next.nil? ? '/]' : '-]-->'}"
  end

end

class L1List
  attr_accessor :head

  def initialize(head = nil)
    @head = head
  end

  # находим нужную запись и предыдущую
  def search(key)
    if @head
      e1 = @head
      e2 = @head.next
      while e2 && e2.key != key
        e1 = e2
        e2 = e2.next
      end
      [e1, e2]
    end
  end

  def del(key)
    if (n = search(key)) && !(n[1].nil?)
      n[0].next = n[1].next
    end
  end

  def insert(key)
    n = L1Node.new(key)
    n.next = @head if @head
    @head = n
  end

  def to_s
    curr = @head
    res = "head[L|#{@head.nil? ? '/]' : '-]-->'}"
    until curr.nil?
      res += curr.to_s
      curr = curr.next
    end
    res
  end
end

head = L1Node.new(0)
for i in 1...10 do
  head = L1Node.new(i, head)
end
list = L1List.new
list.head = head

## Печать созданного списка
puts list

puts list.search(2)
list.del(2)
puts list
list.insert(3)
puts list
