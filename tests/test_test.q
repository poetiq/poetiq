\l test_init.q
.tst.init[`bundler;`bundler1];


.tst.desc["Test Torq"]{
	should["work with torq"]{
		1 musteq 1;
	 };
	should["throw an error"]{
		mustthrow[();(`unknownfunc;`)];
	 };
 };
