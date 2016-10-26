
.lg.banner[]

\d .proc

// variable to check to ensure this file is loaded - used in other files
loaded:1b
// Initialised flag - used to check if the process is still initialisation
initialised:0b

// Read the process parameters
params:@[value;`.proc.params;()],.Q.opt .z.x
// check for a usage flag
if[`usage in key params; -1 .proc.getusage[]; exit 0];

$[`localtime in key params;
	[cp:{.z.P};cd:{.z.D};ct:{.z.T}];
	[cp:{.z.p};cd:{.z.d};ct:{.z.t}]];

localtime:`localtime in key params

// Check if we are in fail fast mode
trap:`trap in key params
stop:`stop in key params
.lg.o[`init;"trap mode (initialisation errors will be caught and thrown, rather than causing an exit) is set to ",string trap]
.lg.o[`init;"stop mode (initialisation errors cause the process loading to stop) is set to ",string stop]
if[trap and stop; .log.o[`init;"trap mode and stop mode are both set to true.  Stop mode will take precedence"]];

// If any of the required parameters are null, try to read them from a file
// The file can come from the command line, or from the environment path
/file:$[`procfile in key params; first `$params `procfile; first getconfigfile["process.csv"]];
/.lg.o[`init;"attempting to read required process parameters ",("," sv string req)," from file ",string file];

// reset the logging functions to now use the name of the process
.lg.o:.lg.l[`INF;proctype;procname;;;()!()]
.lg.e:.lg.err[`ERR;proctype;procname;;;()!()]
.lg.w:.lg.l[`WARN;proctype;procname;;;()!()]

// Create log files as long as they haven't been switched off
if[not any `debug`noredirect in key params; rolllogauto[]];

reloadcommoncode:{loaddir .proc.torqcommon;}
/reloadprocesscode:{loaddir getenv[`KDBCODE],"/",string proctype;}
/reloadnamecode:{loaddir getenv[`KDBCODE],"/",string procname;}

// Load library code
.proc.loadcommoncode:@[value;`.proc.loadcommoncode;1b];
/.proc.loadprocesscode:@[value;`.proc.loadprocesscode;1b];
/.proc.loadnamecode:@[value;`.proc.loadnamecode;0b];
.proc.loadhandlers:@[value;`.proc.loadhandlers;1b];
.proc.logroll:@[value;`.proc.logroll;1]
.lg.o[`init;".proc.loadcommoncode flag set to ",string .proc.loadcommoncode];
/.lg.o[`init;".proc.loadprocesscode flag set to ",string .proc.loadprocesscode];
/.lg.o[`init;".proc.loadnamecode flag set to ",string .proc.loadnamecode];
.lg.o[`init;".proc.loadhandlers flag set to ",string .proc.loadhandlers];
.lg.o[`init;".proc.logroll flag set to ",string .proc.logroll];

if[.proc.loadcommoncode; .proc.reloadcommoncode[]]
/if[.proc.loadprocesscode;.proc.reloadprocesscode[]]
/if[.proc.loadnamecode;.proc.reloadnamecode[]]

if[`loaddir in key .proc.params;
	.lg.o[`init;"loaddir flag found - loading files in directory ",first .proc.params`loaddir];
	.proc.loaddir each .proc.params`loaddir]

// Load message handlers after all the other library code
if[.proc.loadhandlers;.proc.loaddir .proc.torqhandlers]

// If the timer is loaded, and logrolling is set to true, try to log the roll file on a daily basis
if[.proc.logroll and not any `debug`noredirect in key .proc.params;
	$[@[value;`.timer.enabled;0b];
		[.lg.o[`init;"adding timer function to roll std out/err logs on a daily schedule starting at ",string `timestamp$(.proc.cd[]+1)+00:00];
		 .timer.rep[`timestamp$.proc.cd[]+00:00;0Wp;1D;(`.proc.rolllogauto;`);0h;"roll standard out/standard error logs";1b]];
		.lg.e[`init;".proc.logroll is set to true, but timer functionality is not loaded - cannot roll logs"]]];

// Load the file specified on the command line
if[`load in key .proc.params; .proc.loadf each .proc.params`load]

if[any`debug`nopi in key .proc.params;
	.lg.o[`init;"Resetting .z.pi to kdb+ default value"];
	.z.pi:show@value@;]

// initialise pubsub
if[@[value;`.ps.loaded;0b]; .ps.initialise[]]
// initialise connections
if[@[value;`.servers.STARTUP;0b]; .servers.startup[]]

.lg.banner[]

// set the initialised flag
.proc.initialised:1b