params[`syms]:@[value;`syms;`AAPL`MSFT];
params[`bgn]:@[value;`bgn;2016.05.01];
params[`end]:@[value;`end;2016.06.01];


.algo.upd[`quote]:{[tm;x]
	0N!tm;
 };

\
.am.init[];
