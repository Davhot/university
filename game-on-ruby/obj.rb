# encoding: utf-8
# содержится: You, Enemy, Orda
#require '~/init.rb'
require_relative './init.rb'
class You < Creation  #собственно главный герой
  def initialize(x = 1, y = 1)
    @x, @y = x, y
    @right, @left, @up, @down = true, true, true, true #для блокировки движения
    @attack = 10
    @lvl = 1
    @xp = 0
    @max_xp = 50
    @gold = 0
    @medkit = 0

    @sword = nil
    @sword_attack = 0
    @all_attack = @attack + @sword_attack

    @max_hp = 100
    @hp = 100

    @armor = nil
    @armor_hp = 0

    @count_enemies = 0
  end
  def kill; @hp = 0; end
  def max_hp; @max_hp; end
  def hp; @hp; end

  def attack; @attack; end
  def lvl; @lvl; end

  def xp; @xp; end
  def max_xp; @max_xp; end

  def x; @x; end
  def y; @y; end

  def count_enemies; @count_enemies; end

  def gold; @gold; end
  def get_gold(n); @gold += n; end

  def medkit; @medkit; end

  def use_medkit
    if medkit > 0
      @hp = @max_hp
      @medkit -= 1
    end
  end
  def get_medkit(n); @medkit += n; end

  def sword_inf; @sword_attack; end

  def add_sword(sw)
    delete_sword if @sword != nil
    if sw != nil
      @sword = sw
      @sword_attack = sw.attack
      @all_attack = @attack + @sword_attack
    end
  end

  def delete_sword
    @sword = nil
    @all_attack -= @sword_attack
    @sword_attack = 0
  end

  def armor_inf; @armor_hp; end

  def add_armor(ar)
    if ar != nil
      if @armor != nil
        delete_armor
      else
        @armor = ar
        @armor_hp = ar.armor
      end
    end
  end

  def delete_armor
    @armor_hp = 0
    @armor = nil
  end

  def move(x, y)
    @x += x
    @y += y
  end

  def add_xp(xp)
    @xp += xp
  end

  def level_up
    while @xp >= @max_xp
      puts "level up!"
      @xp -= @max_xp
      @max_hp += 5 + @lvl
      @attack += 2 + @lvl
      @all_attack = @attack + @sword_attack
      @hp = @max_hp
      @lvl += 1
      @max_xp = 50*@lvl
    end
  end

  def give_damage; @all_attack; end

  def get_damage(n)
    if @armor_hp > 0
      @armor_hp -= n
      if @armor_hp < 0
        @hp -= @armor_hp
        delete_armor
      end
    else
      delete_armor
      @hp -= n
    end
  end

  def fight(e, m)
    system "clear"
    while(@hp > 0 && e.hp > 0)
      system "clear"
      puts "Бой!"
      e.get_damage(give_damage)
      m.display(0)
      print "Здоровье главного героя\t".bg_gray
      puts "Здоровье противника".bg_gray
      print "#{@hp}".green
      print " "*28
      puts "#{e.hp}(-#{give_damage})".red
      if e.hp > 0
        sleep 0.5
        system "clear"
        puts "Бой!"
        get_damage(e.give_damage)
        m.display(0)
        print "Здоровье главного героя\t".bg_gray
        puts "Здоровье противника".bg_gray
        print "#{@hp}(-#{e.give_damage})".green
        print " "*(28-"(-#{e.give_damage})".size)
        puts "#{e.hp}".red
        sleep 0.5
      end
    end
    `clear`
    @count_enemies += 1
  end

end
#////////////////////////////////////////////////////////////////////////////////
class Trank
  def initialize(x, y)
    @x, @y = x, y
    @ch = 'S'
    @gold = rand(0..100)
    @medkit = 1
    @sword = Sword.new
    @armor = Armor.new
  end

  def x; @x; end
  def y; @y; end
  def gold; @gold; end
  def give_gold; @gold = 0; end

  def sword; @sword; end
  def give_sword; @sword = nil; end
  def sword_information
    if @sword == nil
      "Empty"
    else
      "#{@sword.class} (+#{@sword.attack})"
    end
  end

  def armor; @armor; end
  def give_armor; @armor = nil; end
  def armor_information
    if @armor == nil
      "Empty"
    else
      "#{@armor.class} (+#{@armor.armor})"
    end
  end

  def medkit; @medkit; end
  def give_medkit; @medkit = 0; end

  def trank
    @gold != 0 && @med_kit != 0 && @sword != nil && armor != nil ? @ch.brown : @ch.black
  end

end
#///////////////////////////////////////////////////////////////////////////////
class Sword
  def initialize
    @attack = 100
  end
  def attack; @attack; end
end
#///////////////////////////////////////////////////////////////////////////////
class Armor
  def initialize
    @armor = 500
  end
  def armor; @armor; end
end
#///////////////////////////////////////////////////////////////////////////////
class Enemy < Creation
  def initialize(x, y, lvl)
    @x, @y = x, y
    @lvl = lvl
    @hp = 100 * @lvl
    @attack = 10 * @lvl
    @xp = 100 * @lvl #сколько опыта даётся за него
  end

  def is_enemy?(x, y)
    (@x == x && @y == y) ? true : false
  end

  def hp; @hp end

  def xp; @xp end

  def attack; @attack end

  def lvl; @lvl end
end
#/////////////////////////////////////////////////////////////////////////////
class Orda #для орды врагов(можно добавить различных врагов)
  def initialize
    @orda = []
  end

  def add(x, y, lvl)
    for i in 0 ... @orda.size
      if @orda[i].is_enemy?(x, y)
        delete(x, y)
        break
      end
    end
    @orda << Enemy.new(x, y, lvl)
  end

  def delete(x, y)
    for i in 0 ... @orda.size
      if @orda[i] != nil
        if @orda[i].is_enemy?(x, y)
          @orda[i] = nil
          @orda.compact!
        end
      end
    end
  end

  def is_orda?(x, y)
    for i in 0 .. @orda.size
      if @orda[i].is_enemy?(x, y)
        true
        break
      end
      false
    end
  end

  def uniq_enemy(x, y)
    for i in 0 ... @orda.size
        return @orda[i] if @orda[i].is_enemy?(x, y)
    end
  end

  def orda; @orda end
end

class Tunnel
  def initialize(x, y)
    @x = x
    @y = y
    @tunnel = 'o'.bg_green
  end
  def tunnel; @tunnel; end
  def x; @x; end
  def y; @y; end
end
