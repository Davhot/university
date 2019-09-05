# I - 1, V - 5, X - 10, L - 50, C - 100, D - 500, M - 1000
#перевод из 10-й с.с. в римскую до 4999
def ten_to_rome(n)
  s = ""
  while n >= 1000
    s += 'M'
    n -= 1000
  end
  if n >= 900
    s += 'CM'
    n -= 900
  end
  if n >= 500
    s += 'D'
    n -= 500
  end
  if n >= 400
    s += 'CD'
    n -= 400
  end
  while n >= 100
    s += 'C'
    n -= 100
  end
  if n >= 90
    s += 'XC'
    n -= 90
  end
  if n >= 50
    s += 'L'
    n -= 50
  end
  if n >= 40
    s += 'XL'
    n -= 40
  end
  while n >= 10
    s += 'X'
    n -= 10
  end
  if n == 9
    s += 'IX'
    n -= 9
  end
  if n >= 5
    s += 'V'
    n -= 5
  end
  if n == 4
    s += 'IV'
    n -= 4
  end
  while n > 0
    s += 'I'
    n -= 1
  end
  s
end
