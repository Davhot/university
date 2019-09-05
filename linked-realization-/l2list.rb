class L2Node
  attr_accessor :key, :prev, :next

  def initialize(k, p = nil, n = nil)
    @key, @prev, @next = k, p, n
  end

  def to_s
    "[#{@prev.nil? ? '/' : '-'}|#{@key}|#{@next.nil? ? '/]' : '-]<=>'}"
  end
end

class L2List
  attr_accessor :head

  def initialize(head = nil)
    @head = head
  end

  def search(key)
    e = @head
    e = e.next while e && e.key != key
    e
  end

  def insert(key)
    n = L2Node.new(key)

    if @head
      n.next = @head
      @head.prev = n
    end
    @head = n
  end

  def delete(key)
    n = search(key)
    if n
      if n.prev
        n.prev.next = n.next
      else
        @head = n.next
      end

      n.next.prev = n.prev if n.next
    end
  end

  def to_s
    curr = @head
    res = "head[L|#{@head.nil? ? '/]' : '-]-->'}"
    until curr.nil?
      res += curr.inspect
      curr = curr.next
    end
    res
  end
end
