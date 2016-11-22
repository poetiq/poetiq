\d .strategy
upd:{
	.oms.calc.fun . .portcon.calc.fun .alpha.calc.fun[];
 }

\d .alpha
dif: { select signal:last deltas price by sym from .sdt.trades}
calc.fun: .alpha.dif

\d .risk


\d .portcon
calc.fun:{[alpha] (`targetsz;select sym, sz:signum signal from alpha) } / (type;data); where type is targetsz or targetw

\d .oms
opensz: ()!() / maps symbols to total size of open orders by symbol
sendorder:{
	opensz[x`sym]+:x`size;
	.market.sendorder[x];
 }

cancelorder:{
	opensz[x`sym]-:x`size;
	.market.cancelorder[x];
 }

calc.fun.targetsz:{
	target:x[`sym]!x`sz;
	if[cnt:count delta:(where delta <>0)#delta:target-opensz;
	sendorder[([] id:.market.genorderids[cnt]; otype:cnt#`mkt; sym:key delta; size: value delta)]; 
	];
 }

/
calc.fun.targetw: {
	currw:$[0=count .port.w;([sym:`$()]sz:`float$());.port.w];
	targw:select sym, sz:w from x;
	delta:select last sz, px:last hfill (`getpx;first sym) by sym from targw pj neg currw;
	orders:select sym, size:floor .port.equity*sz%px from delta;
	if[count orders; (neg hbtt) (`.u.upd;`order;value flip orders)];
 }

