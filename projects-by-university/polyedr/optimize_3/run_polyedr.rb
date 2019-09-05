#!/usr/bin/env ruby
require_relative './polyedr'
require_relative '../common/tk_drawer'
%w(ccc cube box king cow).each do |name|
  puts '======================================================================='
  puts "Начало работы с полиэдром '#{name}'"
  start_init_time = Time.now
  print 'Инициализация --------------------------------> '
  poly = Polyedr.new("../data/#{name}.geom")
  start_optimize_time = Time.now
  printf "%7.2f сек.\n", start_optimize_time - start_init_time
  puts 'Начало оптимизации'
  poly.optimize
  start_shadow_time = Time.now
  printf "Время оптимизации ----------------------------> %7.2f сек.\n", 
  start_shadow_time - start_optimize_time
  print 'Удаление невидимых линий ---------------------> '
  poly.shadow
  start_draw_time = Time.now
  printf "%7.2f сек.\n", start_draw_time - start_shadow_time
  print 'Изображение полиэдра -------------------------> '
  thread = TkDrawer.create
  poly.draw
  printf "%7.2f сек.\n", Time.now - start_draw_time
  print 'Hit "Return" to continue -> '
  thread.kill
  gets
end
