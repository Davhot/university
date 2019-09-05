s = gets
k = 0
s1 = 'YES'
for i in 0 ... s.size
  if k < 0
    s1 = 'NO'
    break
  end
  case s[i]
  when "("
    k += 1
  when ")"
    k -= 1
  end
end
s1 = 'NO' if k != 0
puts s1
