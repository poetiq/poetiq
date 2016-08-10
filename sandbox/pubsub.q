/ subs table to keep track of current subscriptions
subs:2!flip `handle`func`params`curData!"is**"$\:()

/pubsub functions
sub:{`subs upsert (.z.w;x;y;res:eval(x;enlist y));(x;res)}

.z.ws:{ if[`ec in system "B"; 0N!"redrawing";neg[.z.w] -8!(enlist `hist)!enlist 0!`dt`val xcol ec]}
0N!.z.w