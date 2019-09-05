#!/usr/bin/env ruby
require 'getoptlong'
opts = GetoptLong.new(
  [ '--help',    '-h',            GetoptLong::NO_ARGUMENT ],
  [ '--version', '-v',            GetoptLong::NO_ARGUMENT ],
  [ '--method',  '-m',            GetoptLong::REQUIRED_ARGUMENT ],
  [ '--size',    '-s',            GetoptLong::REQUIRED_ARGUMENT ],
  [ '--type',    '-t',            GetoptLong::REQUIRED_ARGUMENT ],
  [ '--print',   '-p',            GetoptLong::NO_ARGUMENT ]
)
opts.quiet = true

@version = '1.0'

# Собственно запуск теста
def run_tests
  if @size.nil?
    print 'Введите количество чисел для сортировки -> '
    @size = gets.to_i
  end
  if @type.nil?
    print 'Введите тип массива:
  отсортированный - 0,
  инвертированный - 1,
  случайный       - 2,
     тип массива -> '         
    @type = gets.to_i
  end
  arr = case @type
        when 0
          (0...@size).to_a
        when 1
          (0...@size).to_a.reverse
        when 2
          (0...@size).to_a.shuffle
        end
  p arr if @print
  time_start = Time.now
  method(@method).call(arr)
  time_end = Time.now
  p arr if @print
  printf "Время, затраченное на сортировку массива: %6.2f сек.\n", time_end - time_start
end

begin
  name = File.basename($0)
  @usage = <<USAGE

Использование: 
  #{name} имя_файла_с_одноимённым_методом_сортировки [--size size] [--type type] [--print] 

Примеры:
  #{name} -m bubblesort -p
  #{name} -m bubblesort
  #{name} --method insertionsort -s 20 -t 2 -p
  #{name} --method insertionsort --size 1000
  #{name} --help
  #{name} --version
USAGE

  @print = false
  opts.each do |opt, arg|
    if opt == '--help' 
      raise @usage
    elsif opt == '--version'
      raise "Version #{@version}"
    elsif opt == '--method'
      @method = arg
    elsif opt == '--size'
      @size = arg.to_i
    elsif opt == '--type'
      @type = arg.to_i
    elsif opt == '--print'
      @print = true
    end
  end
  raise @usage if @method.nil?
  require "./#{@method}"
  @method += '!'
  run_tests
rescue Exception => e
  $stderr.puts e.class.to_s == 'GetoptLong::InvalidOption' ? @usage : e
  exit 1
end
