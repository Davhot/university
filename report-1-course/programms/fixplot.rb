#!/usr/bin/env ruby

### Номер обрабатываемой функции (последняя по умолчанию)
NUM = -1

### Массив данных
PLOTD = [ 
# sin
  [
   -4.33333, 4.33333, -2.0, 2.0,
   "Math.sin(x)",
   "Math.cos(x)",
   -4.33333, 0.11111, 26
  ],
# cos
  [
   -4.33333, 4.33333, -2.0, 2.0,
   "Math.cos(x)",
   "-Math.sin(x)",
   -4.33333, 0.11111, 26
  ],
# acos
  [
   -4.33333, 4.33333, -4.33334, 4.33333,
   "Math.cos(x)",
   "-Math.sin(x)",
    0.0, 0.1314, 8
  ]
] 

### Размер рисунка (в миллиметрах) в данном случае ВЫЧИСЛЯЕТСЯ!
###                              Единица масштаба по осям: 8мм.
### x_win
### y_win

### Максимальные и минимальные координаты в окне рисования
x_min = PLOTD[NUM][0]
x_max = PLOTD[NUM][1]
y_min = PLOTD[NUM][2]
y_max = PLOTD[NUM][3]

### Функция
def func(x)
  eval(PLOTD[NUM][4])
end

### Eё производная
def dfunc(x)
  eval(PLOTD[NUM][5])
end

### Начальное значение
x0 = PLOTD[NUM][6]

### Шаг
st = PLOTD[NUM][7]

### Количество кривых Безье
nm = PLOTD[NUM][8]

#########################################################

HEAD = '
\documentclass[b5paper,11pt]{memoir}
\usepackage{graphicx}
\usepackage{pgf,pgfarrows}

\definecolor{plot1}{cmyk}{0.9,0.5,0.0,0.0} 
% Второй цвет гистограмм и графиков
\definecolor{plot2}{cmyk}{0.0,0.60,0.70,0.0} 
% Цвет для заливки гистограмм
\definecolor{plot3}{cmyk}{0.05,0.05,0.0,0.0}
% Толщина линии у графиков
\newlength\plotwidth
\setlength{\plotwidth}{1.2pt}

% Цвет для клеточек
\definecolor{gridcolor}{cmyk}{0.30,0.00,0.0,0.0}
% Толщина линии у клеточек
\newlength\gridwidth
\setlength{\gridwidth}{0.8pt}
% Макрос для включения клеточек
\newcommand{\mygrid}[4]{
\begin{pgfscope}
\pgfsetlinewidth{\gridwidth}\color{gridcolor}
\pgfgrid[step={\pgfxy(0.5,0.5)}]{\pgfxy(#1,#2)}{\pgfxy(#3,#4)}
\end{pgfscope}
}

\begin{document}
\thispagestyle{empty}
\begin{figure}[ht!]
\centering
'

TAIL = '
\end{pgftranslate}
\end{pgfpictureboxed}
\end{figure}
\end{document}
\endinput'

def pgfcurve(f,x,st,y0,y1,y2,y3)
  if PLOTD[NUM].size == 9
    f.printf("\\pgfxycurve(%7.3f,%7.3f)(%7.3f,%7.3f)(%7.3f,%7.3f)(%7.3f,%7.3f)\n", x, y0, x+st, y1, x+2*st, y2, x+3*st, y3) 
  else
    f.printf("\\pgfxycurve(%7.3f,%7.3f)(%7.3f,%7.3f)(%7.3f,%7.3f)(%7.3f,%7.3f)\n", y0, x, y1, x+st, y2, x+2*st, y3, x+3*st) 
  end
end

File.open("tmp.tex", "w") do |f|
  x_m, y_m = 8.0, 8.0
  x_mm, y_mm = 0.8/x_m, 0.8/y_m
  x_win = x_m*(x_max - x_min)
  y_win = y_m*(y_max - y_min)

  f.puts HEAD
  f.printf("\\begin{pgfpictureboxed}{0mm}{0mm}{%7.3fmm}{%7.3fmm}\n",
           x_win,y_win)
  f.printf("\\pgfsetxvec{\\pgfpoint{%7.3fmm}{0mm}}\n",x_m)
  f.printf("\\pgfsetyvec{\\pgfpoint{0mm}{%7.3fmm}}\n",y_m)
  f.printf("\\begin{pgftranslate}{\\pgfpoint{%7.3fmm}{%7.3fmm}}\n",
           -x_min*x_m, -y_min*y_m)

  f.puts '%'
  f.puts '\pgfsetendarrow{\pgfarrowsingle}'
  f.printf("\\pgfxyline(%7.3f,0)(%7.3f,0)\n",x_min,x_max)
  f.printf("\\pgfxyline(0,%7.3f)(0,%7.3f)\n",y_min,y_max)
  f.puts '\pgfclearendarrow'
  f.puts '%'
  f.printf("\\pgfputat{\\pgfxy(%7.3f,%7.3f)}{\\pgfbox[right,base]{\\small$O$}}\n",-x_mm,-y_mm*4.8)  
  f.printf("\\pgfxyline(1,%7.3f)(1,%7.3f)\n",-y_mm,y_mm)
  f.printf("\\pgfputat{\\pgfxy(%7.3f,%7.3f)}{\\pgfbox[center,base]{\\small 1}}\n",1,-y_mm*4.8)  
  f.printf("\\pgfxyline(%7.3f,1)(%7.3f,1)\n",-x_mm,x_mm)
  f.printf("\\pgfputat{\\pgfxy(%7.3f,%7.3f)}{\\pgfbox[right,center]{\\small 1}}\n",-x_mm,1)  
  f.printf("\\pgfputat{\\pgfxy(%7.3f,%7.3f)}{\\pgfbox[right,base]{\\small $X$}}\n",x_max,-y_mm*4.8)  
  f.printf("\\pgfputat{\\pgfxy(%7.3f,%7.3f)}{\\pgfbox[right,top]{\\small $Y$}}\n",-x_mm,y_max)  
  f.puts '%'
  f.puts '\color{plot1}'
  f.puts '\pgfsetlinewidth{\plotwidth}'

  for i in 0...nm
    y0 = func(x0)
    y1 = y0 + dfunc(x0)*st
    y3 = func(x0+3*st)
    y2 = y3 - dfunc(x0+3*st)*st
    pgfcurve(f,x0,st,y0,y1,y2,y3)    
    x0 += 3*st
  end
  
  f.puts TAIL    
end

`pdflatex tmp.tex`
`evince tmp.pdf`
`mv tmp.tex fun.tmp`
`rm tmp.*`
