.tst.init:{[proctype;procname]
	.proc.proctype:proctype;
	.proc.procname:procname;
	.proc.params.noredirect:1b;
	system"l ",getenv[`POETIQ],"/torq.q"
 };
