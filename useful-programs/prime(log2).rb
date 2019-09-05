# является ли число простым
def prime(n)
  for i in 2 .. n**(1/2.0)
    return false if n % i == 0
  end
  true
end
p prime(1231)
