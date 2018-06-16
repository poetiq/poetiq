/ library of math & statistical functions
pch:{deltas[x]%prev x}

\d .math
/
round: {
	.lg.tic[];
	xabs:abs x;
	.lg.toc[`math.round.xabs];.lg.tic[];
	x05:0.5 + xabs;
	.lg.toc[`math.round.05plus];.lg.tic[];
	xfloor:floor x05;
	.lg.toc[`math.round.floor];.lg.tic[];
	r:signum[x]*xfloor;
	.lg.toc[`math.round.signum];
	/.lg.toc[`math.round];
	/r:signum[x] * floor 0.5 + abs x;
	r
 }
\
round:{[d;n]  
	//https://groups.google.com/forum/#!topic/personal-kdbplus/VMduB32vz7I
	/ faster alternative: x*"j"$y%x
	if[d=0;:"j"$n]; / for speed
	("j"$n*d) % d:xexp[10]d

 }

rnd:{x*"j"$y%x} / .math.rnd[1] 4.554 https://groups.google.com/forum/#!topic/personal-kdbplus/W7rZ7R8dvQo

\d .stat

/ TODO: consider for speed using fby (avg;rank l) fby l . See https://groups.google.com/forum/#!topic/personal-kdbplus/HR5ZWh4CNw86
pcrank:{                                          / percentile rank, nearest rank method (https://en.wikipedia.org/wiki/Percentile)
n:asc x where not null x;                       / sorted vector excluding nulls
  if[not count n;:0n];                            / return 0n when all nulls
  (sums[count each group n]%count n) @ x          / map vector to cumulative fractions formed from counting by group of same values
  }                                               / usage: pcrank[0N 1 2 0N 2 1 5] / 0n 0.4 0.8 0n 0.8 0.4 1

seq:{x+z*til ceiling(1+y-x)%z}  				  / sequence from to step. Each paralelizes to a vector
quantile:{seq[0;100;100%x] binr y}  			  / x-th quintile memberships of y. Vigintile: x=5
quantilename:{(`median`terciles`quartiles`quintiles`sextiles`septiles`octiles`deciles`duodeciles`hexadeciles`vigintiles`percentiles`permiles!2 3 4 5 6 7 8 10 12 16 20 100 1000) x}

/ seq[0f;100f;5f] binr 0 0.1 4.99 5 5.01 56 89.999 90.0001 94.999 95 95.1 100
/ 0 1 1 1 2 12 18 19 19 19 20 20
/ quintile[; 0 0.1 4.99 5 5.01 56 89.999 90.0001 94.999 95 95.1 100] each `vigintile`quintile!5 10
/ vigintile| 0 1 1 1 2 12 18 19 19 19 20 20
/ quintile | 0 1 1 1 1 6  9  10 10 10 10 10
