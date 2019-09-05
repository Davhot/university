#!/usr/bin/env ruby
require_relative './polyedr'
require_relative '../common/tk_drawer'
TkDrawer.create
%w(ccc cube box king cow).each do |name|
  puts '============================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_time = Time.now
  Polyedr.new("../data/#{name}.geom").draw
  puts "Изображение полиэдра '#{name}' заняло #{Time.now - start_time} сек."
  print 'Hit "Return" to continue -> '
  gets
end
