\e 1
\c 2000 2000

r:{
	system "cd F:/poetiq";
	/system "cd C:/Projects/q/poetiq";
	{system "l src/",string x;} each `lg.q`dt.q`sdt.q`port.q;
	system "l strategy/","strategy1.q";
	system "l src/market/","market.q";
	system "l src/bt.q";
	.lg.level::`e;
	.bt.run[];
	/.lg.dump[];
 }