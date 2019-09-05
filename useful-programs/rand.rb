#encoding: UTF-8
#!/usr/bin/env ruby
#программа рандомит номера заданий для участников

s = ["Вася", "Петя", "Вова", "Галя", "Наташа", "Никита", "Саша", "Настя", "Катя", "Даня"] #участники рандома
n = s.size #количество участников рандома
n_beg_rand = 10 #с какого числа рандом
n_end_rand = 15 #до какого
delta_rand = n_end_rand - n_beg_rand

a1 = Array.new(n_end_rand+1,0)
a2 = Array.new(n_end_rand+1,0)
numb_a = 2 #количество массивов
i = 1 #номер участника

while i <= n
  k1 = rand(numb_a) + 1 #рандомит из какого массива брать число
  k2 = rand(n_beg_rand .. n_end_rand) + 1 #рандомит число в первом массиве
  k3 = rand(n_beg_rand .. n_end_rand) + 1 #рандомит число во втором массиве
  case k1
  when 1
    redo if a1[k2] == nil
    puts "#{i}. #{s[i-1]} 1.#{k2}"
    a1[k2] = nil
  when 2
    redo if a2[k2] == nil
    puts "#{i}. #{s[i-1]} 2.#{k2}"
    a2[k2] = nil
  end
  i += 1
end
