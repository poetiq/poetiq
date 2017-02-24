.tst.desc["Strategy 1 result"]{
 	should["have last equity 100010.2"]{
 		env.cfg.paths: getenv[`POETIQ],/: ("src/";"strategy/strategy1.q");
 		backtest[env];
 		equity musteq 100010.2;
 		.proc.purge[];
 	};
 };