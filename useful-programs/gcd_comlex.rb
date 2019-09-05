print "z1: "
x1 = gets.split.map{|x| x.to_i}
print "z2: "
x2 = gets.split.map{|x| x.to_i}
z1 = Complex(x1[0],x1[1])
z2 = Complex(x2[0],x2[1])
def gcd_complex(z1, z2)
  null = Complex(0,0)
  x = z1.real**2+z1.imag**2
  y = z2.real**2+z2.imag**2
  z1, z2 = z2, z1 if x < y
  z3 = z1/z2
  r = z3.real.round
  i = z3.imag.round
  z3 = z1 - z2 * Complex(r,i)
  while z3 != null
    z1 = z3
    z1, z2 = z2, z1
    z3 = z1/z2
    r = z3.real.round
    i = z3.imag.round
    z3 = z1 - z2 * Complex(r,i)
  end
  z2 *= Complex(0,1) while z2.real < 0 || z2.imag < 0
  z2
end
p gcd_complex(z1, z2)
