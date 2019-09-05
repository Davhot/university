def countingsort!(list)
  min = list.min
  max = list.max
 
  # make an array of each value, with the number of times it occurs.
  # subtract min, to normalize as well as to allow for negative numbers.
  counts = Array.new(max-min+1, 0)
  list.each{|n| counts[n-min] += 1}
 
  # make a sorted array, repeating values per counts array
  list.replace (0...counts.size).map{|i| [i + min] * counts[i]}.flatten
end
