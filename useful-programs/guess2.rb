include Math
printf("\tPress 1 - to play\n\t")
i = gets.to_i;
while(true)
  printf("\tChoose game\n
  \t 1 - AGAINST COMPUTER, 2 - SINGLE OR MULTIPLAYER 3 - EXIT \n\t")
  chs = gets.to_i
  if(chs == 3)
    break
  end
  if (chs == 1)
    max = 100
    min = 0
    mid = 50
    moves = 1
    option = '~'
    printf("guess a number(0..100)\n\t")
    while(true)
      puts "\e[H\e[2J"
      printf("\tAre your number >, < or = %d?\n\t", mid)
      option = gets.to_s
      if(option == "exit\n")
        break
      end

      if(option == ">\n")
        min = mid
        mid = (min + max) / 2
      elsif (option == "<\n")
        max = mid
        mid = (min + max) / 2

      else
        printf("\tmoves = %d\n\t", moves)
        printf("Your number: %d\n\t", mid)
        printf("PC wins\n\t")
        break
      end
      moves += 1
    end

  elsif(chs == 2)
    printf("\tChoose game mode\n
    \t1 - Single\n
    \t2 - Multiplayer\n");
    mode = gets.to_i;
    printf("\tChoose difficult\n
    \t1 - Easy(10 moves)\n
    \t2 - Medium(7 moves)\n
    \t3 - Hard (5 moves)\n\t");
    cc = gets.to_i;
    if (cc == 1)
      hp = 10;
    end
    if (cc == 2)
      hp = 7;
    end
    if (cc == 3)
      hp = 5;
    end
    ln = hp;
    if (i==1)
      printf("\tMatch the number from 0 to 100\n\n\t");
      if (mode == 1)
        randNum = rand(100);
      end
      if (mode == 2)
        printf("\tType the number 0 to 100\n\n\t");
        randNum = gets.to_i;
        puts "\e[H\e[2J";
        while (randNum>100)
          printf("\tNumber should be <=100\n\n\t")
          randNum = gets.to_i;
          puts "\e[H\e[2J";
          printf("\tType the number 0 to 100\n\n\t");
        end
        printf("\tMatch the number\n\n\t");
      end
      for a in 1..10 do
        des = gets.to_i;
        hp-=1;
        if (des>randNum)
          printf("\tTry smaller\n\t You have %d HP \n\t", hp);
        end
        if (des<randNum)
          printf("\tTry bigger\n\t You have %d HP \n\t", hp);
        end
        if (des == randNum)
          printf("You win!!!\n\t");
          break;
        end
        if (a==ln)
          printf("You loose\n\t");
          break;
        end
      end
    end
  end
end
