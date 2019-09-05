#encoding: UTF-8
print "Введите числа через точку-запятую(;): "
a = gets.split(";").map{|x| x.to_i}
n = a.size
for i in 0 ... n/2
  a[i], a[-1-i] = a[-1-i], a[i]
end
a.size.times{|i| print "#{a[i]} "}
puts
