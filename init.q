/ sets up default environment. User can then change configuration on the fly and run backtest from q prompt

/ testq bt.q /c/poetiq/tests/test_strat.q -cfg src -strat /c/poetiq/strategy/strategy1.q

/ q init.q -cfg src
/ testq init.q /c/poetiq/tests/test_strat.q -cfg src

/args: .Q.def[`cfg`strat!(`:src/;`)] .Q.opt .z.x
.utl.require "qutil"
args: .Q.def[enlist[`cfg]!enlist `:src/] .Q.opt .z.x
.prm.upd:{
	 break;
	qopt:.Q.opt .z.x;
	listargs: (where 1<count each qopt)#qopt;
 	argdict: .Q.def[1_ get[`.prm] ] (`strat`cfg,key listargs) _ qopt;
 	ty:.Q.t type each argdict[key listargs];
 	argdict[key listargs]:value upper[ty]$listargs; / attempt to parse q list passed via command line
 	@[`.; key argdict;: ; value argdict];
 }

/.util.loadpath: {system "l ", $[10h=type x; x; ":"= first string x; 1_string x; string x]; } / cd:system "cd"; system "cd ", cd
.util.loadpath: {cd:system "cd"; system "l ", $[10h=type x; x; ":"= first string x; 1_string x; string x]; system "cd ", cd;} / cd:system "cd"; system "cd ", cd
.proc.purge:{ {if[count key x;![x;();0b; key[x]  except ` ]]} each `.blot`.bt`.clock`.dt`dt`.lg`.log`.market`.oms`.port`port`.strategy`timer;
			delete margin, pos, ob from `.;} 
/.cfg.loadfile:{ if[not all `oms`market`port`bt in `.; .util.loadpath x;]};
/.strategy.loadfile:{ system "l ", .util.path x; }

.util.loadpath args `cfg;

.lg.tic[];
$[null args `strat; 0N!"No strategy specified: entering POETIQ dev mode."; .util.loadpath args `strat] ; /.util.loadpath args `strat];
.lg.toc[`strat];