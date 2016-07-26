/ Copy of qspec's testrunner.q with a few minor modifications in order to run on TorQ

.utl.require"qspec"
.tst.loadOutputModule["text"];
.tst.app.excludeSpecs:();
.tst.app.runSpecs:();
.tst.output.mode: `run

.tst.app.describeOnly:0b
.tst.app.xmlOutput:0b
.tst.app.runPerformance:0b
.tst.app.passOnly:0b
.tst.app.exit:1b
.tst.app.failFast:0b
.tst.app.failHard:0b
.utl.DEBUG:1b

.tst.app.specs:()

.tst.app.expectationsRan:0
.tst.app.expectationsPassed:0
.tst.app.expectationsFailed:0
.tst.app.expectationsErrored:0

.tst.callbacks.descLoaded:{[specObj];
 .tst.app.specs,:enlist specObj;
 }

if[not[.tst.app.describeOnly] and not .tst.app.passOnly; / Only want to print this when running to see results
 .tst.callbacks.expecRan:{[s;e];
  .tst.app.expectationsRan+:1;
  r:e[`result];
  if[r ~ `pass; .tst.app.expectationsPassed+:1];
  if[r in `testFail`fuzzFail; .tst.app.expectationsFailed+:1];
  if[r like "*Error"; .tst.app.expectationsErrored+:1];
  if[.tst.output.interactive;
    1 $[r ~ `pass;".";
     r in `testFail`fuzzFail;"F";
     r ~ `afterError;"B";
     r ~ `afterError;"A";
     "E"];
     ];
  if[(.tst.app.failFast or .tst.app.failHard) and not r ~ `pass;
    s[`expectations]:enlist e;
    1 "\n",.tst.output.spec s;
    if[.tst.app.failHard;.tst.halt:1b];
    if[.tst.app.exit and not .tst.app.failHard;exit 1];
    ];
  }
 ];

/ \d .
.tst.loadTests hsym `$.proc.params[`test];
/ \d .tst

if[.tst.app.failHard;.tst.app.specs[;`failHard]: 1b];
if[not .tst.app.runPerformance;.tst.app.specs[;`expectations]: {x .[;();_;]/ where x[;`type] = `perf} each .tst.app.specs[;`expectations]];
if[0 <> count .tst.app.runSpecs;.tst.app.specs: .tst.app.specs where (or) over .tst.app.specs[;`title] like/: .tst.app.runSpecs];
if[0 <> count .tst.app.excludeSpecs;.tst.app.specs: .tst.app.specs where not (or) over .tst.app.specs[;`title] like/: .tst.app.excludeSpecs];

.tst.app.results: $[not .tst.app.describeOnly;.tst.runSpec each .tst.app.specs;.tst.app.specs]

if[not .tst.halt;
 .tst.app.passed:all `pass = .tst.app.results[;`result];
 if[not .tst.app.passOnly;
  if[.tst.output.interactive and not .tst.app.describeOnly;-1 "\n"];
  if[.tst.output.always or not .tst.app.passed;
   -1 {-1 _ x} .tst.output.top .tst.app.results;
   ];
  if[not .tst.app.describeOnly;
   if[.tst.output.interactive;
    -1 "For ", string[count .tst.app.specs], " specifications, ", string[.tst.app.expectationsRan]," expectations were run.";
    -1 string[.tst.app.expectationsPassed]," passed, ",string[.tst.app.expectationsFailed]," failed.  ",string[.tst.app.expectationsErrored]," errors.";
    ];
   ];
  ];

 if[.tst.app.exit; exit `int$not .tst.app.passed];
 ];
