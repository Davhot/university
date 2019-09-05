#перевод из римской в 10-ю с.с. до 4999
require './rome_s_s.rb'
def rome_to_10(s)
  b = []
  a = {'I' => 1, 'V' => 5, 'X' => 10, 'L' => 50, 'C' => 100, 'D' => 500, 'M' => 1000}
  for i in 0 ... s.size - 1
    b << a[s[i]]
    b[-1] *= -1 if a[s[i]] < a[s[i+1]]
  end
  b << a[s[-1]]
  b.inject(0){|i, sum| sum += i}
end
p ten_to_rome(4999)
p rome_to_10('MMMMCMXCIX')
for i in 1 ... 4999
  p i if rome_to_10(ten_to_rome(i)) != i
end
