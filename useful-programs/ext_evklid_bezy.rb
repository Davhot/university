#encoding: UTF-8
def gcd_ext(a, b)
  #gcd и коэф Безу
  x1, x2, y1, y2 = 1, 0, 0, 1
  r1, r2 = a, b
  while r2 > 0
    q, r = r1.divmod(r2)
    x1, x2 = x2, x1 - q * x2
    y1, y2 = y2, y1 - q * y2
    r1, r2 = r2, r
  end
  return r1, x1, y1
end
if __FILE__ == $0
  a, b = 345, 123
  d, x, y = gcd_ext(345, 123)
  puts "gcd(#{a}, #{b}) = #{d} : Коэффициенты Безу #{x}, #{y}"
  puts
end

def inverce(a, m)
  #обратный элемент
  g, x = gcd_ext(a, m)
  return g == 1 ? (x % m + m) % m : "No solution"
end
if __FILE__ == $0
  a, b = 31, 14
  puts "Обратный элемент к #{a} по модулю #{b}: #{inverce(a, b)}"
  puts
end

def all_inverse(m)
  # m -- is prime!
  #все обратные элементы
  r = {}
  r[1] = 1
  for i in 2 ... m
    r[i] = (m - (m/i) * r[m % i] % m) % m
  end
  r
end
if __FILE__ == $0
  p all_inverse(17)
  puts
end

def solve_equation(a, b, c)
  # ax+by=c
  g, x, y = gcd_ext(a, b)
  d = c/g
  return c%g == 0 ? [d*x, d*y] : "No solution"
end
if __FILE__ == $0
  a, b, c = 24, 16, 48
  x, y = solve_equation(a, b, c)
  puts "#{a}x + #{b}y = #{c} : x = #{x}, y = #{y}"
  puts
end

def solve_congruences(a, b, m)
  #ax=c(mod m) одно из решений сравнения
  g, x = gcd_ext(a, m)
  return g == 1 ? (x % m + m)*b % m : "No solution"
end
if __FILE__ == $0
  a, b, c = 31, 7, 14
  x = solve_congruences(a, b, c)
  puts "#{a}x = #{c}(mod #{c}) : x = #{x}"
  puts
end
