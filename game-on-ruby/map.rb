# encoding: utf-8
#содержится: Map, Меню(метод)
#require '~/obj.rb'
require_relative './obj.rb'

def open_menu_trank(y, t)
  i = 0
  while (true)
    begin
      s, s1 = [], []
      s[0]="Взять всё".bg_blue
      s[1]="Золото: #{t.gold}".bg_cyan
      s[2]="Аптечка: #{t.medkit}".bg_green
      s[3]="Оружие: #{t.sword_information}".bg_red
      s[4]="Броня: #{t.armor_information}".bg_green
      s[5]="Выход".bg_blue

      s1[0]="Взять всё"
      s1[1]="Золото: #{t.gold}"
      s1[2]="Аптечка: #{t.medkit}"
      s1[3]="Оружие: #{t.sword_information}"
      s1[4]="Броня: #{t.armor_information}"
      s1[5]="Выход"
      system "clear"
      for j in 0 ... s1.size
        print "#{j + 1})"
        (i == j) ? puts("#{s[j]}") : puts("#{s1[j]}".black)
      end
      system("stty raw -echo")
      str = STDIN.getc
      case str
      when "A"
        i-=1 if i != 0
      when "B"
        i+=1 if i != s.size - 1
      when "\r"
        case i
        when 0
          y.get_gold(t.gold)
          t.give_gold
          y.get_medkit(t.medkit)
          t.give_medkit
          y.add_sword(t.sword)
          t.give_sword
          y.add_armor(t.armor)
          t.give_armor
          break
        when 1
          y.get_gold(t.gold)
          t.give_gold
        when 2
          y.get_medkit(t.medkit)
          t.give_medkit
        when 3
          y.add_sword(t.sword)
          t.give_sword
        when 4
          y.add_armor(t.armor)
          t.give_armor
        when 5
          break
        end
        system "clear"
      end
    ensure
      system("stty -raw echo")
    end
    `clear`
  end
end

class Map #карта, на которой всё инициализируется и запускается
  def initialize(e = Orda.new, y = You.new)
    @you = y
    @right, @left, @up, @down = true, true, true, true
    @w = Walls.new #создание стен
    @enemy = e
    @e = @enemy.orda
    create_walls
    @m = Matrix.new
    @t = Trank.new(8, 8)
    @tunnel = Tunnel.new(@you.x, @you.y)
    # @sword = Array.new(3, Sword.new)
  end
  #/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  def create_walls
    for i in -1 .. SizeM - 1
      @w.add_walls(-1, i)
      @w.add_walls(i, -1)
      @w.add_walls(SizeM - 1, i)
      @w.add_walls(i, SizeM - 1)
    end
  end
  #/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  def event


    x = @you.x
    y = @you.y
    m = @m.get_matrix

    bottom = m[x][y + 1]
    top =    m[x + 2][y + 1]
    right =  m[x + 1][y + 2]
    left =   m[x + 1][y]
    center = m[x + 1][y + 1]

    @up = top == @t.trank || top == @w.wall ? false : true
    @down = bottom == @t.trank || bottom == @w.wall ? false : true
    @right = right == @t.trank || right == @w.wall ? false : true
    @left = left == @t.trank || left == @w.wall ? false : true

    puts "Спереди сундук. Нажмите 'o' чтобы открыть." if top == @t.trank
    puts "Сзади сундук. Нажмите 'o' чтобы открыть." if bottom == @t.trank
    puts "Справа сундук. Нажмите 'o' чтобы открыть." if right == @t.trank
    puts "Слева сундук. Нажмите 'o' чтобы открыть." if left == @t.trank

    puts "Спереди противник #{top.lvl} уровня: HP(#{top.hp}), Attack(#{top.attack})" if top.class == Enemy
    puts "Сзади противник #{bottom.lvl} уровня: HP(#{bottom.hp}), Attack(#{bottom.attack})" if bottom.class == Enemy
    puts "Справа противник #{right.lvl} уровня: HP(#{right.hp}), Attack(#{right.attack})" if right.class == Enemy
    puts "Слева противник #{left.lvl} уровня: HP(#{left.hp}), Attack(#{left.attack})" if left.class == Enemy
  end
  #/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  def start(c, end_map = false)  #end_map = true - последняя карта, c - номер локации
    system "clear"
    puts
    @m.add(@w)
    @m.add(@enemy)
    @m.add(@t)
    @m.add_you(@you.x, @you.y)
    puts "Начните движение стрелками"
    while (true)

      x = @you.x
      y = @you.y
      m = @m.get_matrix
      bottom = m[x][y + 1]
      top =    m[x + 2][y + 1]
      right =  m[x + 1][y + 2]
      left =   m[x + 1][y]

      begin
        system("stty raw -echo")
        str = STDIN.getc;
        @m.delete(@you.x, @you.y)
        case str
        when "A"
          @you.move(1, 0) if @up
        when "B"
          @you.move(-1, 0) if @down
        when "D"
          @you.move(0, -1) if @left
        when "C"
          @you.move(0, 1) if @right
        when 'o'
          if bottom == @t.trank || top == @t.trank || right == @t.trank || left == @t.trank
            system("stty -raw echo")
            open_menu_trank(@you, @t)
          end
        when 'h'
          if @you.medkit > 0
            if @you.hp == @you.max_hp
              puts "You don't need a medkit"
              sleep 1
            else
              @you.use_medkit
            end
          else
            puts("You haven't got a medkit")
            sleep 1
          end
        when 'q'
          @you.kill
          break
        end
      ensure
        system("stty -raw echo")
      end
      system "clear"
      @m.add(@enemy)
      @m.add(@t)
      @m.add_you(@you.x, @you.y)
      #Событие - бой
      for i in 0 ... @e.size
        if @e[i].x == @you.x && @e[i].y == @you.y
          puts "Противник #{@e[i].lvl} уровня: HP(#{@e[i].hp}), Attack(#{@e[i].attack})"
          @you.fight(@e[i],@m)
          if @you.hp > 0
            puts "Опыта получено: #{@e[i].xp}\n\n"
            sleep 1
            system "clear"
          end
        end
      end
      #
      puts "Location №#{c}"
      @m.display(0)
      puts "(#{@you.x} ; #{@you.y})"
      puts "HP : #{@you.hp}/#{@you.max_hp}"
      puts "Armor : #{@you.armor_inf}"
      puts "Attack : #{@you.attack} + #{@you.sword_inf}"
      puts "XP: #{@you.xp}/#{@you.max_xp}"
      puts "lvl : #{@you.lvl}"
      puts "Gold: #{@you.gold}"
      puts "Med kit: #{@you.medkit} (press 'h')"
      puts "Kill enemies: #{@you.count_enemies}"
      puts "Exit (press 'q')\n\n"
      event if @e != nil
      if @you.hp <= 0
        puts "\e[H\e[2J"
        a = @enemy.uniq_enemy(@you.x, @you.y)
        puts "Противник #{a.lvl} уровня: HP(#{a.hp}), Attack(#{a.attack})"
        puts "Главный герой: HP(#{@you.hp}), Attack(#{@you.attack})"
        sleep 2
        @m.display(3)
        sleep 1
        break
      end
      for i in 0 .. @e.size - 1
        if @e[i] != nil
          if @e[i].hp <= 0
            @you.add_xp(@e[i].xp) #при выигрыше у противника повышается опыт
            @you.level_up
            @m.delete(@e[i].x, @e[i].y)
            @e[i] = nil
            @e.compact!
          end
        end
      end
      if @e[0] == nil
        @m.add(@tunnel)
        if(@you.x == @tunnel.x && @you.y == @tunnel.y)
          if end_map then @m.display(1); sleep 2; end
          break
        end
      end
    end
    system "clear"
    @you
  end
end
#///////////////////////////////////////////////////////
class Maps
  def lets_game
    @end_map = true
    @count = 1
    @enemy = Orda.new
    create_enemies
    @m1 = Map.new(@enemy)
    y = @m1.start(@count)
    create_enemies(1)
    unless y.hp <= 0
      @m2 = Map.new(@enemy, y)
      @m2.start(@count+=1, @end_map)
    end
  end
  def create_enemies(n = 0)
    if n == 0
      # for i in 3 .. 6
      #   for j in 3 .. 6
      #     @enemy.add(i, j, 1)
      #     @enemy.add(i + 4, j + 4, 3)
      #     @enemy.add(i, j+4,2)
      #     @enemy.add(i+4, j, 4)
      #     @enemy.add(i+6, j+6, 10)
      #   end
      #   @enemy.add(3, 3, 15)
      # end
      for i in 3 .. 10
        for j in 3 .. 10
          @enemy.add(i, j, rand(3))
        end
      end
    else
      # for i in 3 .. 6
      #   for j in 3 .. 6
      #     @enemy.add(i, j, 10)
      #     @enemy.add(i + 4, j + 4, 20)
      #     @enemy.add(i+4, j, 50)
      #     @enemy.add(i+6, j+6, 70)
      #   end
      #   @enemy.add(3, 3, 80)
      # end
      for i in 3 .. 10
        for j in 3 .. 10
          c = rand(0 .. 1)
          @enemy.add(i, j, rand(3..6))
          @enemy.add(i, j, 0) if c == 0
        end
      end
    end
  end

end

#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
def start
  aa = "Start".bg_blue
  ai = "Start".black
  ba = "Exit".bg_blue
  bi = "Exit".black
  i = 0
  while (true)
    begin
      system "clear"
      print("\t\t\t#{aa}\t #{bi}\t") if i == 0
      print("\t\t\t#{ai}\t #{ba}\t") if i == 1
      system("stty raw -echo")
      str = STDIN.getc
      case str
      when "D"
        i-=1 if i != 0
      when "C"
        i+=1 if i != 1
      when "\r"
        if i == 1
          system "clear"
          break
        elsif i == 0
          map = Maps.new
          map.lets_game
        end
      end
    ensure
      system("stty -raw echo")
    end
    puts "\e[H\e[2J"
  end
end
