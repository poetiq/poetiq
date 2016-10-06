/ set WebSocket handle execute the parse tree sent from js; e.g. ("loadPage";())
.z.ws:{ value -9!x}

subs:flip `handle`view!"is"$\:()
sub:{`subs upsert (.z.w; x); x}
pubsub:{0N!"pubsub";pub[.z.w] sub[x]}
.z.pc: {delete from `subs where handle=x}
pub:{neg[x] -8!0!value y}
pub:{if[`ec in system "B"; 0N!"redrawing"; neg[x] -8!0!`time`ec xcol value y]} / publishes data if changes in the view exist
loadPage:{pubsub[`ec]}

refresh:{select {[h;v] pub[h] `ec}'[handle;view] from `subs;}

// trigger refresh every 100ms
.z.ts:{refresh[]}
\t 100