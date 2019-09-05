def insertionsort!(list)
  for i in 1 ... list.size
    value = list[i]
    j = i - 1
    while j >= 0 and list[j] > value
      list[j + 1] = list[j] 
      j -= 1
    end
    list[j + 1] = value
  end
  list
end

