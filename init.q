/ sets up default environment. User can run backtest from q prompt and change configuration on the fly.
/ $ bt src F:/lib/Stockopedia/Q/strategy/stockranks.q --exgrp EU --mktcap.sel 5 --mktcap.bins "0 1 10 50 100 350" --qnth 10

.utl.require "qutil"
.utl.require "src/lg.q"
.utl.require "src/util.q"

/ preprocess key-value pair into list of four - see signature of .utl.addOptDef
.utl.arg.proc:{(string x; 
  $[1<count y; (),upper .Q.ty y; 105h=type y; "*"; .Q.ty y]; 
  y; 
  $[10h=abs type y;(x; {value x});x])}

/ Parses strategy arguments as provided via CLI during configuration time. 
/ Exported function that can be called from strategy file. Registers strategy parameters and their defaults.  
loadParams:{
	.utl.arg.args: opts;
	f: { enlist $[(::) ~ v:get x; enlist (::) ; / exclude environment headers (::)
		`upd~first p:except[` vs x] ``prm; enlist (::) ; / exclude .prm.upd itself
		  .utl.arg.proc [` sv p;v] ] }; / add options from the environment
	.utl.addOptDef .' .util.xtree[; `.prm] f ;
	.utl.parseArgs[]; / parse options
 }

.proc.purge:{ {if[count key x;![x;();0b; key[x]  except ` ]]} each `.blot`.bt`.clock`.dt`dt`.lg`.log`.market`.oms`.port`port`.strategy`timer;
			delete margin, pos, ob from `.;}

/ parse CLI arguments
if[count .utl.arg.args;
	.utl.addArg["S"; enlist `:src; (),0; (`.prm.cfg;{ hsym each x}) ];
	/.utl.addOpt["json";"*";(`.prm.json;{.j.k raze x})];
	args: #[;.utl.arg.args] i:min count[.utl.arg.args] , first where .utl.arg.args like "--*";
	opts: i _.utl.arg.args; .utl.arg.args: args; / assumption: options start after first "--", filepaths before
	.utl.parseArgs[]]; /positional arguments. Options are parsed afterwards.


/ loads files provided from positional CLI arguments
.lg.tic[];
$[.util.exists `.prm.cfg; .util.loadpath each .prm.cfg;
	0N!"No strategy specified: entering POETIQ dev mode."];
.lg.toc[`strat];

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