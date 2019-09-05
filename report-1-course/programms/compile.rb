def compile(str)
  @data.clear
  s1 = ""
  "(#{str})".each_char do |c|
    if c =~ /[0-9]/
      s1 += c
    else
      process_symbol(s1) if s1 != ""
      s1 = ""
    end
    process_symbol(c) if s1 == ""
  end
  @data.join(' ')
end
