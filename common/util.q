\d .util


/ Return some or all of the process arguments using .Q.opt except that arguments are razed if
/ they are singleton lists.

args: {
	o: .Q.opt .z.x;
	if [count o; o: (key o) ! {$[1 = count x; raze x; x]} each value o];
	$[count x; o x; o]
	}


/ Print the string x to the console if it is not null.

printif: {if [any not null x; -1 x];}

\d .