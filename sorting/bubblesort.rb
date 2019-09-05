def bubblesort!(list)  
  for i in 0 ... list.size  
    for j in 0 .. (list.size-i-2)  
      list[j],list[j+1] = list[j+1],list[j] if list[j+1] < list[j]  
    end  
  end  
  list
end
