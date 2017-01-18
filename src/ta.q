/ collection of technical analysis functions and indicators

\d .ta

/ crossover: returns +1i if x crosses above y, -1i otherwise. Handles NAs
.ta.xover:{deltas 0<fills x - y} 
/.ta.xover[ -1 0.1 1 .1 0N 0 .1 0 -1; 0]
/.ta.xover[ 1 3 5 1; 1 2 4 3] / simulated MA2 crossover. observe first crossover is not true
