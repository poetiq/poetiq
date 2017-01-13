/ library of statistical functions

\d .stat

seq:{x+z*til ceiling(1+y-x)%z} / sequence from to step. Each paralelizes to a vector
quantile:{seq[0;100;100%x] binr y} / x-th quintile memberships of y. Vigintile: x=5
quantilename:{(`median`terciles`quartiles`quintiles`sextiles`septiles`octiles`deciles`duodeciles`hexadeciles`vigintiles`percentiles`permiles!2 3 4 5 6 7 8 10 12 16 20 100 1000) x}

/ seq[0f;100f;5f] binr 0 0.1 4.99 5 5.01 56 89.999 90.0001 94.999 95 95.1 100
/ 0 1 1 1 2 12 18 19 19 19 20 20
/ quintile[; 0 0.1 4.99 5 5.01 56 89.999 90.0001 94.999 95 95.1 100] each `vigintile`quintile!5 10
/ vigintile| 0 1 1 1 2 12 18 19 19 19 20 20
/ quintile | 0 1 1 1 1 6  9  10 10 10 10 10