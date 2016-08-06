\d .bt

debugstep:{0b}

stepnext:{{(neg x)(`.u.pub;`data;`)}each .am.handles[];};

init:{[bgn;end;syms;delta]
	starttime::.z.P;
	(neg first .am.handles[])(`init;bgn;end;syms;delta)
 };

start:{
	.lg.o[`backtest;"Backtest started"];
	stepnext[];
 };

end:{
	endtime::.z.P;
	.lg.o[`backtest;"Backtest complete"];
	stats[];
 };

stats:{
	-1 "\nStatistics:";
	s:enlist[]!enlist[];
	s[`from]:.am.scope`bgn;
	s[`to]:.am.scope`end;
	s[`bars]:.am.i;
	s[`starttime]:"z"$.bt.starttime;
	s[`endtime]:"z"$.bt.endtime;
	s[`runtime]:`time$.bt.endtime-.bt.starttime;
  show 1 _s};