def check_symbol(c)
  raise "Недопустимый символ '#{c}'" if c !~ /[0-9]+/ || c.to_i > 3999
end
