/ q bt.q -cfg src -strat strategy/strategy1.q

args: .Q.def[`cfg`strat!(`:src/;`)] .Q.opt .z.x

system "l ", getenv[`POETIQ], 1_string hsym args `cfg;
$[`=args `strat; 0N!"POETIQ dev mode: No strategy specified"; system "l ", 1_string hsym args `strat];
.lg.level::`e;

.bt.run[];
/.lg.dump[];