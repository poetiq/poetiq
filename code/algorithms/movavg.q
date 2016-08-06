/ Simple noving average crossover algorithm
params[`syms]:@[value;`syms;`AAPL`MSFT];
params[`bgn]:@[value;`bgn;2016.05.01];
params[`end]:@[value;`end;2016.06.01];


.algo.upd[`quote]:{[tm;x]
	show tm;
	fast:avg history[50;`bidclose];
	slow:avg history[200;`bidclose];

	if[any b:fast>slow; -1 "BUY ",/:string where b];
 };

\
.am.init[];
