#encoding: UTF-8
a = Hash.new
q = "qwertyuiop[]asdfghjkl;'zxcvbnm,./QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>? "
w = "йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ, "
for i in 0 ... q.size
  a[q[i]] = w[i]
  a[w[i]] = q[i]
end
b = gets.chomp
for i in 0...b.size
  print "#{a[b[i]]}"
end
puts
