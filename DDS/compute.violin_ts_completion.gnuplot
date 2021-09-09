#!/usr/bin/gnuplot

######## PARAMS ########## gnuplot -e "FILE='xyz.data'"
NODES=10 #64, 128, 192, 384
##########################
END_Y_RANGE=490 #490, 1300, 2390, 5590
AUTO_FREQ=100 #100, 200, 400, 800
#DFS="data/FLESnet/DFS.ts_comp_dur.".NODES."N.sample.data"
DFS="/Volumes/DataFiles-D/Lise/FLESnet/lise-6165999-fles_libfabric_DFS/"
#FLES="data/FLESnet/FLES.ts_comp_dur.".NODES."N.sample.data"
FLES="/Volumes/DataFiles-D/Lise/FLESnet/lise-6165996-fles_libfabric_DFS/"
####

###### See comments below for the steps to produce such a plot ######

set terminal pdf enhanced size 9cm,4cm font 'Helvetica,10'

set xlabel 'Timeslice no. [1] ('.NODES.' nodes)'
set ylabel 'Completion duration [ms]'
#set xtics format '%0.s%c' autofreq 100000
set xtics nomirror out
set ytics nomirror out
set grid ytics mytics
set xrange[0:100]
set yrange[-40:END_Y_RANGE]
#set ytics autofreq AUTO_FREQ


set output 'FLES_arrival_duration_violin_'.NODES.'.pdf'
load "dark2.plt"

# (1) you can look at this scattered plot to get an impression of your data
set border 2
set xrange [33:36]
set xtics ("FLESnet" 34, "DFS" 35)
set xtics nomirror scale 0
set ytics nomirror rangelimited
unset key

# adjust the overlap and spread parameter for amplitude, depends on the number of data rows
# adjust pointsite as well
# can be slow with many data rows
# cannot adjust amplitude to different datapoint numbers per dataset
#set jitter overlap first 1
set jitter overlap .001 spread .01
set style data points

set linetype  9 lc "#80bbaa44" ps 0.2 pt 5
set linetype 10 lc "#8033bbbb" ps 0.2 pt 5
unset yrange
unset xrange

# can take some time with many data rows
#plot FLES using (34.0):($2/1000) lt 9, \
#     DFS using (35.0):($2/1000) lt 10

# (2) you plot the kdensity on the y axis,
#     - keep weights proportional to 1/N, where N is the number of data points in this dataset
#     - reduce *weight for lower amplitude
#     - reduce *densitybw if the plot does not start at the bottom
#     - increase *densitybw if too much detailed spikes are visible

# x curves
set style data filledcurves below
set auto x
#set xtics 0,50,500
unset ytics
set ytics nomirror out
set border 3
#set margins screen .15, screen .85, screen .15, screen .85
set key
unset xtics
set xtics nomirror out
#set yrange [.02:]

if ( 64 == NODES ) {
   dfsweight=.013 #64, 1 million entries
   flesweight=.013 #64, 1 million entries
   dfsdensitybw=3 #64, groups of four
   flesdensitybw=3 #64, groups of four
}
if ( 128 == NODES ) {
   dfsweight=.03 #128, 1 million entries
   flesweight=.03 #128, 1 million entries
   dfsdensitybw=5 #128, groups of four
   flesdensitybw=5 #128, groups of four
}
if ( 192 == NODES ) {
    dfsweight=.13 #192, 1 million entries
    flesweight=.13 #192, 1 million entries
    dfsdensitybw=5 #192, groups of four
    flesdensitybw=5 #192, groups of four
}
if ( 384 == NODES ) {
   dfsweight=.33 #384, 3 million entries 1/3 = 0.33
   flesweight=.25 #384, 4 million entries 1/4 = 0.25
   dfsdensitybw=15 #384, groups of four, 5*3
   flesdensitybw=20 #384, groups of four, 5*4
}
set xlabel 'Completion duration [ms]'
set ylabel 'kdensity with ('.NODES.' nodes)'

plot  DFS using ($2/1000):(dfsweight) smooth kdensity bandwidth dfsdensitybw with filledcurves above y ls 5 title 'DFS', \
     FLES using ($2/1000):(flesweight) smooth kdensity bandwidth flesdensitybw with filledcurves above y ls 6 title 'FLESnet'

# (3) we plot the rotated kdensity, 1/2 to the left and 1/2 to the right at x=1 and x=3
#     - adjust *weight so that the amplitude +/- x looks good
set label "▷ smaller is better" rotate by -90 left at graph 1.02,1 font ",9"
#set label "◁ larger is better" rotate by -90 left at graph 1.02,1 font ",9"
unset yrange
# generate temprary table in variable to work on that and plot it later
set table $kdensity1
plot DFS using ($2/1000):(dfsweight) smooth kdensity bandwidth dfsdensitybw with filledcurves above y ls 6 title 'DFS'
set table $kdensity2
plot FLES using ($2/1000):(flesweight) smooth kdensity bandwidth flesdensitybw with filledcurves above y lt 5 title 'FLESnet'
unset table
unset key
unset xlabel
set ylabel 'Completion duration [ms]'
set xlabel 'Density of distribution ('.NODES.' nodes)'


set border 2
unset xtics
set xtics ("FLESnet" 1, "DFS" 3) nomirror scale 0
#set ytics nomirror rangelimited
unset yrange
set xrange [-1:5]
plot $kdensity2 using (1-$2/20.):1 with filledcurve x=1 ls 6 title 'FLESnet', \
     '' using (1 + $2/20.):1 with filledcurve x=1 ls 6 t '', \
     $kdensity1 using (3+$2/20.):1 with filledcurve x=3 ls 5 t 'DFS', \
     '' using (3-$2/20.):1 with filledcurve x=3 ls 5 t ''

set output 'FLES_arrival_duration_violin_box_'.NODES.'.pdf'
set xlabel 'Density of distribution, Min, Max (bar: 1st-3rd quartile, median) ('.NODES.' nodes)'
#set style fill solid bo -1
set boxwidth 0.1
set errorbars lt black lw .5
set style boxplot nooutliers fraction 1.0
replot FLES using (1):($2/1000) with boxplot fs transparent solid .5 border lc "black" fc "white" lw .5, \
       DFS using (3):($2/1000) with boxplot fs transparent solid .5 border lc "black" fc "white" lw .5
# (4) (above) replot (3) and add a boxplot with min/max, quartiles and median


#plot \
#FLES using 1:($2/1000)  ls 6 ps 0.5 pt 1 w lines t 'FLESnet', \
#DFS using 1:($2/1000)  ls 5 ps 0.5 pt 2 w lines t 'DFS'
