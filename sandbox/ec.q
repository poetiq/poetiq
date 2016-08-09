.z.ws:{value -9!x}
subs:flip `handle`view!"is"$\:()
sub:{`subs upsert (.z.w; x); x}
pubsub:{pub[.z.w] sub[x]}
.z.pc: {delete from `subs where handle=x}
pub:{neg[x] -8!value y}
loadPage:{pubsub[`ec]}

/
h:neg hopen `:localhost:5000
pubsub[`ec]
subs

neg[252] -8!ec

string `ec
ev