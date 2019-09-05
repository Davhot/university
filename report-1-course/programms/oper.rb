def oper_with_n_p(a, b, op = "add")
  case R2Point.intersect(a, b)
  when 1
    op == "add" ? @n_point += 1 : @n_point -= 1
  when "infinity"
    op == "add" ? @n_infinity += 1 : @n_infinity -= 1
  end
  @n_points = (@n_infinity > 0 ? "infinity" : @n_point)
end
