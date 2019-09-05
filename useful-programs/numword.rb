#Ввод чисел до 50_000
def number_to_word(n)
  a = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eigh", "nine", "ten", "eleven", "twelve", "thirteen"]
  b = ["teen", "ty", "twenty", "thirty", "forty", "fifty"]
  c = ["hundred", "thousand"]
  s = []
  q = n
  if q == 0
    s << a[0]
  else
    if q > 19_999
      n = q / 10_000
      n1 = q / 1000
      n1 = n1 % 10
      s << b[n]
      s << a[n1] if n1 != 0
      s << c[1]
      q %= 1_000
    end
    if q > 13_999
      n = q / 1_000
      n %= 10
      s << a[n]+b[0]
      s << c[1]
      q %= 1_000
    end
    if q > 999
      n = q / 1_000
      s << a[n]
      s << c[1]
      q %= 1_000
    end
    if q > 99
      n = q / 100
      s << a[n]
      s << c[0]
      q %= 100
    end
    if q > 59
      n = q / 10
      s << a[n]+b[1]
      q %= 10
    end
    if q > 19
      n = q / 10
      s << b[n]
      q %= 10
    end
    if q > 13
      n = q % 10
      n != 5 ? s << a[n]+b[0] : s << "fifteen"
      q /= 100
    end
    case q
    when 0
    when 8
      s << a[q]+'t'
    else
      s << a[q]
    end
  end
  s1 = ""
  s.size.times{|i| s1 += s[i]; s1 += ' ' if i != s.size-1}
  s1
end
f = File.open("numbers.out", 'a+')
50_001.times{|i| f.print "#{i} "; f.puts number_to_word(i)}
