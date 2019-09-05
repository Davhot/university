#!/usr/bin/env ruby
require_relative "./convex"

fig = Void.new
begin
  while true
    fig = fig.add(R2Point.new)
    puts "S = #{fig.area}, P = #{fig.perimeter}"
  end
rescue EOFError
  puts "\nStop"
end
