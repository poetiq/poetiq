.tst.args:{[proctype;procname]
	procs:2!("SS*";enlist csv)0: hsym`$getenv[`KDBCONFIG],"/start.csv";
	args:.Q.opt " " vs raze system"eval echo ",procs[(proctype;procname);`cmd]
 };

.tst.init:{[proctype;procname]
	.proc.params:.tst.args[proctype;procname];
	.proc.params,:(!). flip 2 cut (
			`noredirect;							1b;
			`.servers.DISCOVERYRETRY;	enlist"0";
			`.servers.RETRY;					enlist"0"
	 );
	system"l ",getenv[`POETIQ],"/torq.q"
 };
