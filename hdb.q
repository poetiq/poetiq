args:.Q.opt .z.x

loaddir:{@[{system"l ",x;-1"Loaded ",x}; x; {-1"Failed to load ",x," : ",y}[x]];}

reload:{
	-1"Reloading hdb ...";
	system"l .";
 }

loaddir string first `$args`load
