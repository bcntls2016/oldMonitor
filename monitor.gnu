#!/usr/bin/gnuplot

set term postscript eps enhanced color "Helvetica-Light,18"
set encoding iso_8859_1
set out OUTPUT
unset key
set xlabel "time / [ps]"
set mxtics 2
set mytics 2
load Observable
