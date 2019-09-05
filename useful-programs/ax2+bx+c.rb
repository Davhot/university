#Программа вычисления корней квадратного уравнения
include Math
a, b, c = gets.to_f, gets.to_f, gets.to_f
if a == 0    #b*x + c = 0
  if b == 0  #c = 0
    puts "Infinity"
  elsif c != 0
    puts "x = #{Rational(c,b)}"
  else       #b*x = 0
    puts "x = 0"
  end
elsif b == 0 #a*x*x + c = 0
  if (c/a) <= 0
    if c == 0  #a*x*x = 0
      puts "x = 0"
    else
      puts "x1 = #{sqrt(c/a)}"
      puts "x2 = #{-sqrt(c/a)}"
    end
  else
    puts "No decision"
  end
elsif c == 0  #a*x*x + b*x = 0 => x*(a*x + b) = 0
  puts "x1 = 0"
  puts "x2 = #{-b/a}"
else
  d = b * b - 4 * a * c
  if d < 0
    puts "No decision"
  elsif d == 0
    puts "x = #{-b/(2*a)}"
  else
    puts "x1 = #{(-b+sqrt(d)) / (2*a)}"
    puts "x2 = #{(-b-sqrt(d)) / (2*a)}"
  end
end
