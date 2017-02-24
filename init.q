/ sets up default environment. User can run backtest from q prompt and change configuration on the fly.
/ $ bt src F:/lib/Stockopedia/Q/strategy/stockranks.q --exgrp EU --mktcap.sel 5 --mktcap.bins "0 1 10 50 100 350" --qnth 10

.utl.require "qutil"
.utl.require "src/lg.q"
.utl.require "src/util.q"

/ preprocess key-value pair into list of four - see signature of .utl.addOptDef
.utl.arg.proc:{(string x; 
  $[1<count y; (),upper .Q.ty y; 105h=type y; "*"; .Q.ty y]; 
  y; 
  $[10h=abs type y;(` sv `.cfg.prm, x; {value x});` sv `.cfg.prm, x])};

/ Parses strategy arguments as provided via CLI during configuration time. 
/ Exported function that can be called from strategy file. Registers strategy parameters and their defaults.  
loadParams:{
	if[.util.exists[`.utl.arg.deferredOpts];
		.utl.arg.args: .utl.arg.deferredOpts;
		f: { enlist $[(::) ~ v:get x; enlist (::) ; / exclude environment headers (::)
		  .utl.arg.proc [` sv except[` vs x] ``prm; v] ] }; / add options from the environment
		.utl.addOptDef .' .util.xtree[; `.prm] f ;
		.utl.parseArgs[];]; / parse options
	`.cfg.prm upsert 1_key[`.cfg.prm]_.prm;
	@[{`. upsert get x}; `.cfg.prm; {}];
 }

.proc.purge:{ {if[count key x;![x;();0b; key[x]  except ` ]]} each `.blot`.bt`.cfg`.clock`.dt`dt`.lg`.log`.market`.oms`.port`port`.strategy`timer;
			delete margin, pos, ob from `.;}

/ parse CLI arguments
if[count .utl.arg.args;
	.utl.addOpt["backtest";1b;`.cfg.bt.run];
	.utl.addArg["S"; enlist `:src; (),0; (`.cfg.paths;{ hsym each x}) ];
	/.utl.addOpt["json";"*";(`.prm.json;{.j.k raze x})];
	bi: where .utl.arg.args in "--",/:.utl.arg[`boolOpts;;0];
	i:where .utl.arg.args in .utl.arg[`regOpts`regDefOpts;;0];
	args: #[;.utl.arg.args] fi:min count[.utl.arg.args] , first where[.utl.arg.args like "--*"] except (bi,i,i+1);
	.utl.arg.deferredOpts: .utl.arg.args bi, (fi _til count .utl.arg.args) except (i,i+1); 
	.utl.arg.args: args; / assumption: options start after first "--", filepaths before
	.utl.parseArgs[];
 ]; /positional arguments. Options are parsed afterwards.

/ loads files provided from positional CLI arguments
.lg.tic[];
.util.loadpath each @[value;`.cfg.paths;{-1 "Welcome to POETIQ dev mode. Load or specify your strategy here.";()}];
.lg.toc[`strat];

backtest:{
	/.util.loadpath each @[get; `.cfg.paths; ()];
	if[99h=type x;
		if[not `prm~prm:x[`cfg;`prm]; `.cfg.prm upsert prm];
		if[not `paths~p:x[`cfg;`paths]; .util.loadpath each p];
	];
	.log.h: `:f:/log.xls;
	.log.lvl:2;
	.lg.tic[];
	.bt.run[];
	.lg.toc[`bt];
	-1 raze "Elapsed: ", string exec sum `time$tspan from .lg.tm where fun in `bt`strat;
	-1 raze "Last equity: ", string last port.equity.curve[`ec];
	system "l F:/qecvis/ec.q";
	.log.dump[blotter];
 }

if[@[value;`.cfg.bt.run;0b]; backtest[]];
/
/ examples of manual parameter control
.utl.addOptDef["qnth"; "I";10;`qnth];
.utl.addOptDef["freq"; "S";`quarterly;`freq];	
.utl.addOptDef["quantiles"; "S";`deciles;`quantiles];
.utl.addOptDef["mktcap.sel"; "I";5;`mktcap.sel];
.utl.addOptDef["mktcap.bins"; (),"F";0 1 10 50 100 350f;`mktcap.bins ]; /{"f"$value x}
.utl.addOptDef["mktcap.op"; "*"; ">="; (`mktcap.op; {value x})];
.utl.addOptDef["exgrp"; "S"; `UK; `exgrp];
.utl.parseArgs[];