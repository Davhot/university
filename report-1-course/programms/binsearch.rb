# Сдвиг "хвостa" массива вправо при добавлении нового элемента
#
# $Q = b[0] < x \leqslant b[n-1]$
# $R=(0 < i \leqslant n-1) \land (b[i-1] < x \leqslant b[i])$

x, b = -1, [-5, -2, 3, 4, 4, 5]
j, i = 0, b.size - 1
while j+1 != i
  k = (i+j)/2
  b[k] < x ? j = k : i = k
end
puts i
