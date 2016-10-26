\d .proc

port: 5000

ports: 5001 + til 4999

typedir: 1!flip `proctype`dirname!flip (
 `dscvry`discovery;
 `hkp`housekeeping;
 `hdb`hdb;
 `kill`kill;
 `feed`feed;
 `gw`gateway;
 `oms`oms;
 `mkt`market;
 `tick`tickerplant;
 `pfolio`portfolio;
 `btctrl`backtest;
 `portcon`portcon)

update port: 5000+til count typedir from `typedir

// Bespoke config for the discovery service

// Server connection details
\d .servers
CONNECTIONS:`ALL		// list of connections to make at start up
DISCOVERYREGISTER:0b		// whether to register with the discovery service
CONNECTIONSFROMDISCOVERY:0b	// whether to get connection details from the discovery service (as opposed to the static file)
TRACKNONTORQPROCESS:1b 		// whether to track and register non torQ processes throught discovery. 
DISCOVERYRETRY:0D		// how often to retry the connection to the discovery service.  If 0, no connection is made
HOPENTIMEOUT:200 		// new connection time out value in milliseconds
RETRY:0D00			// length of time to retry dead connections.  If 0, no reconnection attempts
RETAIN:`long$0Wp 		// length of time to retain server records
AUTOCLEAN:0b			// clean out old records when handling a close
DEBUG:1b			// log messages when opening new connections

SOCKETTYPE: enlist[`]!enlist ` // Make sure all connections are created as standard sockets
//==========================================================================================

\d .

// Discovery service to allow lookup of clients
// Discovery service attempts to connect to each process at start up
// after that, each process should attempt to connect back to the discovery service
// Discovery service only gives out information on registered services - it doesn't really need to have connected to them
// The reason for having a connection is just to get the attributes.

register:{
	// add the new handle
	.servers.addw .z.w;
	// If there already was an entry for the same host:port as the supplied handle, close it and delete the entry
	// this is to handle the case where the discovery service connects out, then the process connects back in on a timer
	if[count toclose:exec i from .servers.SERVERS where not w=.z.w,hpup in exec hpup from .servers.SERVERS where w=.z.w;
		.servers.removerows toclose];
	// publish the updates
	new:select proctype,procname,hpup,attributes from .servers.SERVERS where w=.z.w;
	(neg ((where ((first new`proctype) in/: subs) or subs~\:enlist`ALL) inter key .z.W) except .z.w)@\:(`.servers.procupdate;new);
	} 


// get a list of services
getservices:{[proctypes;subscribe] 
	.servers.cleanup[];
	if[subscribe; subs[.z.w]:proctypes,()]; 
	distinct select procname,proctype,hpup,attributes from .servers.SERVERS where proctype in ?[(proctypes~`ALL) or proctypes~enlist`ALL;proctype;proctypes],not proctype=`discovery}

// subscriptions - handles to list of required proc types
subs:(`int$())!()

// add each handle
@[.servers.addw;;{.lg.e[`discovery;x]}] each exec w from .servers.SERVERS where .dotz.liveh w / , not hpup in (exec hpup from .servers.nontorqprocesstab);

// try to make each server connect back in 
/ (neg exec w from .servers.SERVERS where .dotz.liveh w)@\:"@[value;(`.servers.autodiscovery;`);()]";
/ (neg exec w from .servers.SERVERS where .dotz.liveh w,not hpup in exec hpup from .servers.nontorqprocesstab)@\:(`.servers.autodiscovery;`);
(neg exec w from .servers.SERVERS where .dotz.liveh w)@\:(`.servers.autodiscovery;`);

// modify .z.pc - drop items out of the subscription dictionary
.z.pc:{subs::(enlist y) _ subs; x@y}@[value;`.z.pc;{;}]

// initialise connections
.servers.startup[]