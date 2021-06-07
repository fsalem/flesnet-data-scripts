#!/usr/bin/gnuplot

######## PARAMS ########## gnuplot -e "FILE='xyz.data'"
NODES=10 #64, 128,192, 384
##########################
END_NUMBER=sprintf("%0.f",(NODES/2)-1)
FILE1=ARG1."/compute.buffer_status.out.stat"
FILE2=ARG2."/compute.buffer_status.out.stat"


set terminal pdf enhanced size 16cm,4cm font 'Helvetica,10'

set xlabel "Connections sorted by buffer fill level [1] (".NODES." nodes)" offset 30
set ylabel 'Fill-Level [%]'
set key right width -2 spacing 1.2 maxrows 4 samplen 2
set xtics nomirror scale 1
set ytics nomirror out scale 0
set grid ytics mytics
#set grid xtics mytics
set yrange [-10:119]
set xtics autofreq 0,1,END_NUMBER

set style data histogram
set style histogram cluster
set style fill solid border -1
set boxwidth 0.9

set offset 5,5,0

set output "FLES_buffer_status_comparison_".NODES.".pdf"
load "dark2.plt"
set label "▷ smaller is better" rotate by -90 left at graph 1.02,1 font ",9"
#set label "◁ larger is better" rotate by -90 left at graph 1.02,1 font ",9"

set multiplot layout 1, 2

plot \
FILE2 u 1:4:2:3:5 t "FLESnet: Min, Max (bar: 10th-90th percentile, median)" w candlesticks ls 6 lw 0.6 whiskerbars, \
''	  u 1:7:7:7:7 with candlesticks lt -1 lw 1.8 notitle

set xlabel offset 40
set ylabel ''
#set format y ''

plot \
FILE1 u 1:4:2:3:5t "DFS: Min, Max (bar: 10th-90th percentile, median)" w candlesticks ls 5 lw 0.6 whiskerbars, \
''	  u 1:7:7:7:7 with candlesticks lt -1 lw 1.8 notitle

unset multiplot

#pause -1


