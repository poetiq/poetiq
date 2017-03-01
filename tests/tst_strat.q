.tst.desc["Strategy 1 result"]{
 	should["have last equity 100010.2"]{
 		env.cfg.paths: `:src/`:strategy/strategy1.q; / ("src/";"strategy/strategy1.q"); / getenv[`POETIQ],/: ("src/";"strategy/strategy1.q");
 		backtest[env];
 		equity musteq 100010.2;
 		.proc.purge[];
 	};
 };