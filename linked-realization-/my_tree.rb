#encoding: UTF-8
class TNode
  attr_accessor :key, :left, :right

  def initialize(k, l = nil, r = nil)
    @key, @left, @right = k, l, r
  end

  # вывод записи и потомков
  def to_s
    k1 = @left.nil? ? nil : @left.key
    k2 = @right.nil? ? nil : @right.key
    s = "Element: #{@key}\n"
    s += "Left child: #{k1}\n"
    s += "Right child: #{k2}\n"
    s
  end
end

class Tree
  attr_accessor :root

  def initialize(root = nil)
    @root = root
  end

  def delete(key)
    # поиск записи
    n = search(key)
    unless n.nil?
      # у удаляемого узла нет потомков(лист)
      if n.left.nil? && n.right.nil?
        if n == @root
          @root = nil
        else
          p = parent(key)
          p.left = nil if p.left == n
          p.right = nil if p.right == n
        end
      # у удаляемого узла один потомок
      elsif !(n.left.nil?) && n.right.nil?
        if n == @root
          @root = n.left
        else
          p = parent(key)
          p.left = n.left if p.left == n
          p.right = n.left if p.right == n
        end

      elsif !(n.right.nil?) && n.left.nil?
        if n == @root
          @root = n.right
        else
          p = parent(key)
          p.left = n.right if p.left == n
          p.right = n.right if p.right == n
        end

      else
        # у удаляемого узла два потомка
        # берём минимальное значение из правого поддерева
        if n == @root
          n = min(n.right)
          n.left = @root.left if @root.left != n
          n.right = @root.right if @root.right != n
          @root = n
        else
          # предок удаляемой записи
          p = parent(key)
          # минимальный элемент в правом поддереве удаляемого элемента
          node = min(n.right)
          # предок минимального элемента
          p2 = parent(node.key)
          # всё правое поддерево элемента, который будет заменён на удаляемый,
          # присоединяем к родителю этого элемента
          p2.left = node.right if p2.right != node
          # вставляем элемент на место удаляемого
          p.left == n ? p.left = node : p.right = node
          node.left = n.left if node != n.left
          node.right = n.right if node != n.right
        end

      end
    end
  end

  # нахождение следующего элемента
  def successor(key)
    # поиск записи
    n = search(key)
    # возвращаем минимальный элемент из правого поддерева
    # в правом поддереве содержатся все элементы больше данного
    return min(n.right) unless (n.nil? || n.right.nil?)
    # иначе идём по тем родителям, у которых данный потомок находится в левом поддереве
    node = parent(n.key)
    while(node != nil && n == node.right)
      n = node
      node = parent(node.key)
    end
    node
  end

  # нахождение предыдущего элемента
  def predecessor(key)
    n = search(key)
    return max(n.left) unless (n.nil? || n.left.nil?)
    node = parent(n.key)
    while(node != nil && n == node.left)
      n = node
      node = parent(node.key)
    end
    node
  end

  # нахождение предка
  def parent(key)
    curr = @root
    curr2 = nil
    while !(curr.nil?)
      return curr2 if curr.key == key
      curr2 = curr
      curr = curr.key > key ? curr.left : curr.right
    end
    nil
  end

  # максимальный элемент поддере с корнем root
  def max(root = @root)
    unless root.nil?
      t = root
      t = t.right while !(t.right.nil?)
      t
    end
  end

  # минимальный элемент поддере с корнем root
  def min(root = @root)
    unless root.nil?
      t = root
      t = t.left while !(t.left.nil?)
      t
    end
  end

  # поиск элемента по ключу
  def search(key)
    curr = @root
    while !(curr.nil?)
      return curr if curr.key == key
      curr = curr.key > key ? curr.left : curr.right
    end
    nil
  end

  # вставляем элемент, если этого элемента ещё нет
  #       7
  #      / \
  #     2  8
  #    / \  \
  #   1  3  9
  #  /\ / \ /\
  #       4
  # Добавляем 5
  #       7
  #      / \
  #     2  8
  #    / \  \
  #   1  3  9
  #  /\ / \ /\
  #       4
  #      / \
  #        5

  # вставка элемента
  def add(t)
    if search(t.key).nil?
      curr1 = @root
      key = t.key
      if curr1.nil?
        @root = t
      else
        while !(curr1.nil?)
          curr2 = curr1
          curr1 = curr1.key > key ? curr1.left : curr1.right
        end
        curr2.key > key ? curr2.left = t : curr2.right = t
      end
    end
  end

  #Обход дерева сверху вниз
  def preorder(curr = @root)
    return if curr.nil?
    print "#{curr.key} "
    preorder(curr.left)
    preorder(curr.right)
  end

  #Обход дерева слева направо
  def inorder(curr = @root)
    return if curr.nil?
    inorder(curr.left)
    print "#{curr.key} "
    inorder(curr.right)
  end

  #Обход дерева снизу вверх
  def postorder(curr = @root)
    return if curr.nil?
    postorder(curr.left)
    postorder(curr.right)
    print "#{curr.key} "
  end

  # высота дерева
  def height_tree
    a1 = [@root]
    a2 = []
    a1.compact!
    n = 0
    while a1.size != 0
      a1.each{|x|; a2 << x.left << x.right}
      n += 1
      a1 = a2
      a1.compact!
      a2 = []
    end
    n
  end

  # вывод дерева по уровням
  def to_s
    h = 2**height_tree
    a1 = [@root]
    a2 = []
    a1.compact!
    s = "Tree\n"
    while h > 1

      a1.each do |x|
        if x == nil
          s += "_".center(h)
          a2 << nil << nil
        else
          s += "#{x.key} ".center(h)
          a2 << x.left << x.right
        end
      end
      s += "\n"
      ((2**height_tree)/h).times{s += "/ \\".center(h)} if h > 2
      s += "\n"
      h/=2
      a1 = a2
      a2 = []
    end
    s
  end

end
if $0 == __FILE__
  puts "Выберите дерево (1,2)"
  opt = gets.to_i
  case opt
  when 1
    tree = Tree.new(TNode.new(7))
    tree.add(TNode.new(5))
    tree.add(TNode.new(12))
    tree.add(TNode.new(4))
    tree.add(TNode.new(6))
    tree.add(TNode.new(10))
    tree.add(TNode.new(19))
    tree.add(TNode.new(9))
    tree.add(TNode.new(11))
    tree.add(TNode.new(13))
    tree.add(TNode.new(20))
    tree.add(TNode.new(18))
    tree.add(TNode.new(17))
    tree.add(TNode.new(16))
    puts tree
    tree.inorder
    puts
    puts "Удаление элемента с ключом 12"
    tree.delete(12)
    tree.inorder
    puts
    puts tree
    puts tree.search(17)
    p tree.height_tree
  when 2
    tree = Tree.new(TNode.new(7))
    tree.add(TNode.new(2))
    tree.add(TNode.new(8))
    tree.add(TNode.new(1))
    tree.add(TNode.new(3))
    tree.add(TNode.new(4))
    tree.add(TNode.new(9))
    tree.add(TNode.new(5))
    puts tree
    puts
    puts "Поиск элемента с ключом 2"
    puts tree.search(2)
    puts
    puts "Поиск родителя элемента с ключом 5"
    puts tree.parent(5)
    puts
    puts "Поиск максимального"
    puts tree.max
    puts
    puts "Поиск минимального"
    puts tree.min
    puts
    puts "Поиск следующего элемента с ключом 5"
    puts tree.successor(5)
    puts "Поиск предыдущего элемента с ключом 4"
    puts tree.predecessor(4)
    puts "Удаление элемента с ключом 2"
    tree.delete(2)
    puts
    puts tree
    puts "Удаление элемента с ключом 7"
    tree.delete(7)
    puts
    puts tree
  end
end
