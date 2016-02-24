
.player.table: ()

.player.i: 0

.player.timer: {
	$[.player.i < count .player.table; [enter enlist .player.table .player.i; .player.i+: 1]; system "t 0"];
	}


/ Play the orders in the given table x, one row every y milliseconds.
/ x is a table or the name of a file containing the table.

play: {
	t: type x;
	.player.table: $[t = 98; x; t = -11; ("SSIFS"; enlist csv) 0: x; 'nyi];
	.player.i: 0;
	.z.ts: .player.timer;
	system "t ", string y;
	}

