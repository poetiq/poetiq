\l common/require.q

require "common/util.q"
require "qx/member.q"
require "qx/seq.q"
require "qx/player.q"

template: enlist `sym`dir`qty`prx`tif ! (`AAA; `BUY; 1000; 0f; `IOC)

enter: {
	x: update id: .seq.allocate count x from x;
	.util.printif @[neg h; (`upd; `new; x); "failed to send order"];
	}

cancel: {
	.util.printif @[neg h; (`upd; `cancel; x); "failed to send cancellation"];
	}
	
h: @[hopen; value .util.args `qx; 0]

/

Enter new orders derived from the template to qx. Cancel orders with specific id's.