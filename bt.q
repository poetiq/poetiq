args: .Q.def[`cfg`strat!(`:src/;`)] .Q.opt .z.x

.param.upd:{
	qopt:.Q.opt .z.x;
	listargs: (where 1<count each qopt)#qopt;
 	argdict: .Q.def[1_ get[`.arg] ] (`strat`cfg,key listargs) _ qopt;
 	ty:.Q.t type each argdict[key listargs];
 	argdict[key listargs]:value upper[ty]$listargs; / attempt to parse q list passed via command line
 	@[`.; key argdict;: ; value argdict];
 }

.util.loaddir: {cd:system "cd"; system "l ", x; system "cd ", cd;};
.util.loaddir getenv[`POETIQ], 1_string hsym args `cfg;

.log.h: `:f:/log.xls
.log.lvl:2


.bt.fromto: -0W 0Wp / 1985.12.01 1986.01.01
/.bt.fromto: 2014.07 2014.08m
/.bt.fromto: -0W 1984.01.01

.lg.tic[];
$[`=args `strat; 0N!"POETIQ dev mode: No strategy specified"; system "l ", 1_string hsym args `strat];
.lg.toc[`strat];
.lg.tic[];
if[not (::)~`.[`dt]; .bt.run[];];
.lg.toc[`bt];

-1 raze "Elapsed: ", string exec sum `time$tspan from .lg.tm where fun in `bt`strat;
-1 raze "Last equity: ", string last port.equity.curve[`ec];

\l F:/qecvis/ec.q

.log.dump[blotter];