#encoding: UTF-8
puts "Программа нахождения X матричной системы уравнений, методом обратной матрицы"
def transpon(a)
  for i in 0 ... a.size
    for j in i + 1 ... a[i].size
      a[i][j], a[j][i] = a[j][i], a[i][j]
    end
  end
  a
end

def get_zero_matrix(n, m)
  i = 0
  w = []
  for i in 0 ... n
    a = []
    for k in 0 ... m
      a << 0
    end
    w << a
    a = []
  end
  w
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

def opr_a(a)
  inv = false
  for i in 0 ... a.size
    if a[i].size != a.size
      puts "Invalid data!"
      inv = true
      break
    end
  end
  if !inv
    if a.size == 2
      s = m2x2(a)
    else
      n = 2 #номер строки, по которой идёт вычисление определителя
      s = 0
      for i in 0 ... a.size
        b = []
        for j in 0 ... a.size
          b[j] = a[j].clone
        end
        b = M_a(b, n - 1, i)
        k = ((-1)**(1+(i+1))) * a[n - 1][i]
        b.size == 2 ? k *= m2x2(b) : k *= opr_a(b)
        s += k
      end
    end
    s
  end
end

def connect_m(a)
  c = []
  b = []
  if a.size == 2
    for k in 0 ... a.size
      for j in 0 ... a.size
        d = []
        for i in 0 ... a.size
          d << a[i].dup
        end
        b[j] = M_a(d, k, j)[0][0] * (-1)**(j+k)
      end
      c << b
      b = []
    end
  else
    for k in 0 ... a.size
      for j in 0 ... a.size
        d = []
        for i in 0 ... a.size
          d << a[i].dup
        end
        koef = ((-1)**(k+j))
        b[j] = (opr_a(M_a(d, k, j))) * koef
      end
      c << b
      b = []
    end
  end
  transpon(c)
end

def inverse_m(a, n)
  a = connect_m(a)
  puts "Присоединённая матрица:"
  for i in 0 ... a.size
    p a[i]
  end
  for i in 0 ... a.size
    for j in 0 ... a[i].size
      a[i][j] *= Rational(1, n)
      a[i][j] = a[i][j].numerator if a[i][j].denominator==1
    end
  end
  a
end

a = []
k = []
b = []
while gets
  a << $_.split.map{|x| x.to_i}
end

for i in 0 ... a.size
  b[i] = a[i][-1]
  a[i].delete_at(-1)
end
puts "Начальная матрица:"
for i in 0 ... a.size
  p a[i]
  k[i] = a[i].dup
end
puts "Матрица B:"
for i in 0 ... b.size
  p b[i]
end
if opr_a(a) != nil
  opr = 0 - opr_a(a)
  puts "Определитель = #{opr}"
  if opr == 0
    puts "Вырожденная матрица!"
  else
    a = connect_m(a)
    puts "Присоединённая матрица:"
    for i in 0 ... a.size
      p a[i]
    end
    #перемножение a на b
    c = get_zero_matrix(a.size, 1).flatten
    for i in 0 ... a.size do
      for j in 0 ... 1 do #размер матрицы B 3x1
        for y in 0 ... a[i].size do
          c[i] += a[i][y] * b[y]
        end
      end
    end
    puts "перемноженная присоединённая матрица на матрицу B:"
    p c
    puts "Искомые значения:"
    for i in 0 ... c.size
      c[i] *= Rational(1, opr)
      c[i] = c[i].numerator if c[i].denominator==1
    end
    p c
  end
end
