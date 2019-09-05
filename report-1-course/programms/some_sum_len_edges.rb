def some_sum_len_edges
  s = 0
  edges.each{|e| s += e.some_len}
  s
end
