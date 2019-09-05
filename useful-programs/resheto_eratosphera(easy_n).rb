#encoding: UTF-8
#решето Эратосфера
print "До какого числа вывод простых чисел?: "
n = gets.to_i
a = (0..n).to_a
a[0] = a[1] = nil
ns = Math.sqrt(n).ceil
for i in 2..ns
  next if a[i] == nil
  (i*i).step(n, i){|j| a[j] = nil}
end
a.compact!
(a.size-1).times{|i| p a[i]}
