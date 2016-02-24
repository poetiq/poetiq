require: {.require.map [type x; x];}

\d .require

verbose: 1b

map: (-11h; 11h; 10h; 0h) ! ({action x;}; {action each x;}; {action `$x;}; {action each `$x;})

loaded: ()

action: {
	if [not x in loaded;
		system "l ", string x;
		loaded,: x;
		if [verbose; -1 "loaded ", string x]
	];
	}

\d .

\

Load once feature, to overcome side effects of scripts that initialise on
loading. Only the first script of the q process needs to use
\l common/require.q. Other scripts use, for example:

	require "common/util.q"
	require ("common/quant.q"; "common/util.q")

or the equivalents using symbol instead of string parameters.

Any resemblance to R is intentional.