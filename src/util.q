
.util.loadpath: {cd:system "cd"; system "l ", $[10h=type x; x; ":"= first string x; 1_string x; string x]; system "cd ", cd;}
.util.tree:{ $[ x ~ k:key x; x; 11h = type k; raze (.z.s ` sv x,) each k;()]} / map a tree (such as file system or q context )
.util.xtree:{$[y ~ k:key y; x y ; 11h = type k; raze (.z.s . x, ` sv y,) each k;()]} / apply function to each node of tree
.util.exists:{x~key x}