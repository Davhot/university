#encoding: UTF-8
puts "Программа вычисления определителя квадратной матрицы любого размера"
a = []
while gets
  a << $_.split.map{|x| x.to_i}
end

def m2x2(a)
  a[0][0]*a[1][1] - a[0][1]*a[1][0]
end

def M_a(a, i, j)
  for n in 0 ... a.size
    a[n][j] = nil
    a[n].compact!
  end
  a[i] = nil
  a.compact!
end

def m_a(a)
  inv = false
  for i in 0 ... a.size
    if a[i].size != a.size
      puts "Invalid data file!"
      inv = true
      break
    end
  end
  if !inv
    if a.size == 2
      s = m2x2(a)
    else
      n = 1 #номер строки, по которой идёт вычисление определителя
      c = (-1)**(n-1)
      s = 0
      for i in 0 ... a.size
        b = []
        for j in 0 ... a.size
          b[j] = a[j].clone
        end
        b = M_a(b, n - 1, i)
        k = ((-1)**(1+(i+1))) * a[n - 1][i] * c
        b.size == 2 ? k *= m2x2(b) : k *= m_a(b)
        s += k
      end
    end
    s
  end
end

p m_a(a) if m_a(a) != nil
