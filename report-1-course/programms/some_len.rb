def some_len
  s = 0
  if @gaps.empty?
    k = (@beg.x + @fin.x)/2.0
    s = ((@beg.x - @fin.x) ** 2 + (@beg.y - @fin.y) ** 2) ** 0.5 if k < 3 && k > 1
  end
  s
end
