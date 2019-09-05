def max_heapify!(a, i, size) # size - размер массива
  i += 1 # индексация начинается с 1
  l = 2 * i
  r = l + 1 # 2 * i + 1
  largest = (l <= size && a[l-1] > a[i-1]) ? l : i
  largest = r if r <= size && a[r-1] > a[largest-1]
  if largest != i
    a[i-1], a[largest-1] = a[largest-1], a[i-1]
    max_heapify!(a,largest-1, size)
  end
end

def build_max_heap!(a)
  (a.size/2).downto(0){|i| max_heapify!(a, i, a.size)}
end

def heapsort!(a)
  n = a.size # количество элементов в массиве
  build_max_heap!(a)
  (n-1).downto(0) do |i|
    a[0], a[i] = a[i], a[0]
    n -= 1
    max_heapify!(a, 0, n)
  end
  a
end

a = []
(10**2+10).times{|i| a << i}
a.reverse!
p a
p heapsort!(a)
p a
