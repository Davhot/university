def R2Point.intersect(p1, p2)
  zero = R2Point.new(0,0)
  ao = p1.dist(zero)
  bo = p2.dist(zero)
  ab = p1.dist(p2)
  cosA = (ao**2+ab**2-bo**2) / (2*ao*ab)
  cosB = (bo**2+ab**2-ao**2) / (2*bo*ab)
  h = nil
  if (0..1).include?(cosA) && (0..1).include?(cosB)
    h = 2.0*R2Point.area(p1, p2, zero).abs/ab
  end
  a = [ao, bo]
  a << h if h != nil
  r = a.min
  if r < 1
    "infinity"
  elsif r == 1
    1
  else
    0
  end
end
