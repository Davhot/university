# encoding: utf-8
# содержится: String, Walls, Creation, Matrix
# SizeM = rand(15 .. 20)
SizeM = 15
class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end
#///////////////////////////////////////////////////////////////////////////////
class Walls
  def initialize
    @walls = []
    @ch = '█'.bold.black
  end

  def wall; @ch; end

  def add_walls(x, y)
    @walls << [x, y]
    @walls.uniq!
  end

  def is_wall?(x, y)
    @walls.include?([x, y]) ? true : false
  end

  def delete_wall(x, y)
    @walls.delete([x, y])
    @walls.compact!
  end

  def return_w; @walls end
end
#///////////////////////////////////////////////////////////////////////////////
class Creation
  def initialize
    @hp = hp
    @attack = attack
  end

  def get_damage(d); @hp -= d end

  def give_damage; @attack end

  def x; @x end

  def y; @y end
end
#///////////////////////////////////////////////////////////////////////////////
class Matrix
  def initialize
    @matrix = []
    for i in 0 .. SizeM
      @matrix << []
      for k in 0 .. SizeM
        @matrix[-1] << nil
      end
    end
  end

  def get_matrix; @matrix end

  def get_elem(x, y)
    @matrix[x][y] != nil ? @matrix[x][y] : nil
  end

  def delete(x, y)
    @matrix[x + 1][y + 1] = nil
  end

  def add(a)

    if a.class == Trank
      x = a.x
      y = a.y
      @matrix[x][y] = a.trank
    end

    if a.class == Orda
      if a.orda[0].class == Enemy
        i = 0
        while a.orda[i] != nil
          x = a.orda[i].x + 1
          y = a.orda[i].y + 1
          if @matrix[x][y] == nil
            @matrix[x][y] = a.orda[i]
          elsif @matrix[x][y].class != Enemy
            a.delete(x - 1, y - 1)
            i -= 1
          end
          i += 1
        end
      end
    elsif a.class == Walls
      for i in 0 .. a.return_w.size - 1
        x = a.return_w[i][0] + 1
        y = a.return_w[i][1] + 1
        @matrix[x][y] = a.wall if @matrix[x][y] == nil
      end
    elsif a.class == Tunnel
      @matrix[a.x + 1][a.y + 1] = a.tunnel
    end

  end

  def add_you(x, y)
    @matrix[x + 1][y + 1] = 'Y'.bold.green
  end

  def display(option)
    if option == 0
      @matrix.reverse!
      for i in 0 .. SizeM #10x10 матрица
        for k in 0 .. SizeM
          if @matrix[i][k].class == Enemy
            print 'E'.red
          else
            if @matrix[i][k] != nil
              print @matrix[i][k]
            else
              print ' '
            end
          end
        end
        puts
      end
      @matrix.reverse!
    elsif option == 1
      system "clear"
      puts "\\     /  _____                                       O           ___".red
      puts " \\   /  [     ] |      |     \\        /\\        /   | |  |\\    | | |".blue
      puts "  \\ /   |     | |      |      \\      /  \\      /    | |  | \\   | | |".cyan
      puts "   |    |     | |      |       \\    /    \\    /     | |  |  \\  | | |".magenta
      puts "   |    |     | |      |        \\  /      \\  /      | |  |   \\ | | |".cyan
      puts "   |    [_____] [______]         \\/        \\/       |_|  |    \\|  O ".gray
    else
      system "clear"
      puts "\\     /  _____                         _____   ____   _____ ".red
      puts " \\   /  [     ] |      |     |        [     ] |    | |     |".red
      puts "  \\ /   |     | |      |     |        |     |  \\     |      ".red
      puts "   |    |     | |      |     |        |     |   \\    |_____ ".red
      puts "   |    |     | |      |     |        |     |    \\_  |      ".red
      puts "   |    [_____] [______]     |______  [_____]  ____] |_____|".red
    end
  end
end
