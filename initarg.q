/ bt2 src F:/lib/Stockopedia/Q/strategy/stockranks.q --exgrp EU --mktcap.sel 5 --mktcap.bins "0 1 10 50 100 350" --qnth 10
/ bt2  "[\">=\",\"MktCapGBP\",350]"
.utl.require "qutil"
.util.loadpath: {cd:system "cd"; system "l ", $[10h=type x; x; ":"= first string x; 1_string x; string x]; system "cd ", cd;} / cd:system "cd"; system "cd ", cd
.utl.addArg["S"; enlist `:src; (),0; (`cfg;{ hsym each x}) ]; 
args: #[;.utl.arg.args] i:first where .utl.arg.args like "--*"
opts: i _.utl.arg.args; .utl.arg.args: args; / assumption: options start after first "--", filepaths before
.utl.parseArgs[]; /parse positional arguments. Options are cached for later

.util.tree:{ $[ x ~ k:key x; x; 11h = type k; raze (.z.s ` sv x,) each k;()]} / map tree
.util.xtree:{$[y ~ k:key y; x y ; 11h = type k; raze (.z.s . x, ` sv y,) each k;()]} / apply function to each node of tree

/ preprocess key-value pair into list of four - see signature of .utl.addOptDef
.utl.arg.proc:{(string x; 
  $[1<count y; (),upper .Q.ty y; 105h=type y; "*"; .Q.ty y]; 
  y; 
  $[10h=abs type y;(x; {value x});x])}

loadParams:{
	/.utl.addOpt["json";"*";(`.prm.json;{.j.k raze x})];
	.utl.arg.args: opts;
	f: { enlist $[(::) ~ v:get x; enlist (::) ; / exclude environment headers (::)
		`upd~first p:except[` vs x] ``prm; enlist (::) ; / exclude .prm.upd itself
		  .utl.arg.proc [` sv p;v] ] }; / add options from the environment
	.utl.addOptDef .' .util.xtree[; `.prm] f ;
	.utl.parseArgs[]; / parse options
 }

.util.loadpath each cfg; / loads files provided from positional CLI argument

/
load cfg, load par
addOpts (from prm context)
parseArgs from CLI
load strat

.utl.addOptDef["qnth"; "I";10;`qnth];
.utl.addOptDef["freq"; "S";`quarterly;`freq];	
.utl.addOptDef["quantiles"; "S";`deciles;`quantiles];
.utl.addOptDef["mktcap.sel"; "I";5;`mktcap.sel];
.utl.addOptDef["mktcap.bins"; (),"F";0 1 10 50 100 350f;`mktcap.bins ]; /{"f"$value x}
.utl.addOptDef["mktcap.op"; "*"; ">="; (`mktcap.op; {value x})];
.utl.addOptDef["exgrp"; "S"; `UK; `exgrp];
.utl.parseArgs[];