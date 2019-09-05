system "clear"
def get_matrix(q)
  puts "Enter size of matrix_#{q}"
  print "n = "
  n = gets.to_i
  print "m = "
  m = gets.to_i
  repeat = true
  i = 0
  while repeat && i != n
    print "Size of matrix_#{q}: #{n}x#{m}\n"
    puts "Enter the elements of matrix_#{q} separated by a space, Enter."
    a = []
    a[0] = nil
    repeat = false
    for i in 1 .. n
      a << [nil]
      a[i] << gets.split.map{|k| k.to_i}
      a[i].flatten!
      if a[i].size != m + 1
        puts "Invalid input, try again!"
        repeat = true
        break
      end
    end
  end
  a
end
#///////////////////////////////////////////////////////////////////////
def get_zero_matrix(n, m)
  i = 0
  a = []
  a[0] = nil
  for i in 1 .. n
    a << [nil]
    for k in 1 .. m
      a[i] << 0
      a[i].flatten!
    end
  end
  a
end
#//////////////////////////////////////////////////////////////////////
def action(a, b, ch)
  c = a
  if b.class == Array
    case ch
    when "+", "-"
      for i in 1 ... a.size do
        for j in 1 ... a[1].size do
          c[i][j] = a[i][j] + b[i][j] if ch == "+"
          c[i][j] = a[i][j] - b[i][j] if ch == "-"
        end
      end
    when "*"
      c = get_zero_matrix(a.size - 1, b[1].size - 1)
      for i in 1 ... a.size do
        for j in 1 ... b[1].size do
          for k in 1 ... a[i].size do
            c[i][j] += a[i][k] * b[k][j]
          end
        end
      end
    end
  elsif ch == "*"
    for i in 1 ... a.size do
      for j in 1 ... a[1].size do
        c[i][j] *= b
      end
    end
  end
  c
end
#/////////////////////////////////////////////////////////////////////
def print_m(a)
  print "\nMatrix:\n"
  for i in 1 ... a.size
    for j in 1 ... a[1].size
      print "a#{i}#{j}=#{a[i][j]}   "
    end
    print "\n\n"
  end
end
#////////////////////////////////////////////////////////////////////
a = get_matrix(1)
repeat = true
while repeat
  repeat = false
  print "Select the operation(+, -, *): "
  ch = gets.to_s.chomp
  print "Select number or matrix(n/m): "
  s = gets.to_s.chomp
  if s == "m"
    b = get_matrix(2)
    case ch
    when "+", "-"
      if a[1].size != b[1].size || a.size != b.size
        puts "Size of matrix_1 != size of matrix_2"
        repeat = true
      else
        print_m(action(a, b, ch))
      end
    when "*"
      if a[1].size != b.size
        puts "The size of string a != the size of column b"
        repeat = true
      else
        print_m(action(a, b, ch))
      end
    end
  elsif s == "n" && ch == "*"
    print "Enter a number: "
    b = gets.to_i
    print_m(action(a, b, ch))
  else
    puts "Invalid input, try again!"
    repeat = true
  end
end
