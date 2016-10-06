\d .bt

debugstep:{0b}

stepnext:{{(neg x)(`.u.pub;`data;`)}each .am.handles[];};

init:{[tbls;bgn;end;syms]
	(first .am.handles[])(`init;tbls;bgn;end;syms)
 };

start:{
	.lg.o[`backtest;"Backtest started"];
	starttime::.z.P;
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
	s[`from]:"z"$.am.scope`bgn;
	s[`to]:"z"$.am.scope`end;
	s[`bars]:.am.i;
	s[`starttime]:"z"$.bt.starttime;
	s[`endtime]:"z"$.bt.endtime;
	s[`runtime]:`time$.bt.endtime-.bt.starttime;
  show 1 _s};
