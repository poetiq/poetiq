///////////////////
// Equal Weights //
///////////////////
/ \d .r
/ r:{`.a.a upsert x}

/ \d .f
/ eqw:{x*1%sum x};
/ long:{x*x>0};
/ wf:{select sym, date, w:.f.eqw .f.long signal, time from x};

/ \d .a
/ a:1!flip`sym`date`signal`time!"sdin"$\:()

/ \d .e
/ e:`targetw

//////////
// Unit //
//////////
/ \d .r
/ r:{`.a.a :x}

/ \d .f
/ units:{[n;x] n*`long$signum x};
/ wf:{select sym, date, sz:.f.units[1] signal, time from x}

/ \d .a
/ a:0N

/ \d .e
/ e:`targetsz