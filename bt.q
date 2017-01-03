/ q bt.q -cfg src -strat strategy/strategy1.q

args: .Q.def[`cfg`strat!(`:src/;`)] .Q.opt .z.x
.util.loaddir: {cd:system "cd"; system "l ", x; system "cd ", cd;};
.util.loaddir getenv[`POETIQ], 1_string hsym args `cfg;
$[`=args `strat; 0N!"POETIQ dev mode: No strategy specified"; system "l ", 1_string hsym args `strat];
.lg.level::`e;

if[not (::)~`.[`dt]; .bt.run[];]
/.lg.dump[];