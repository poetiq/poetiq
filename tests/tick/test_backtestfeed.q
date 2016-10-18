\l test_init.q
.tst.init[`backtestfeed;`backtestfeed1];

.tst.desc["tick - backtestfeed"]{
	before{
		fixtureAs[`quote;`tmpquote];
		`sendreq mock {[x;tbls;bgn;end;syms] enlist[`quote]!enlist tmpquote}
		`scope mock `tbls`bgn`end`syms!(enlist`quote;"p"$2016.05.02;"p"$2016.05.02;enlist`AAPL);
	};
	should["set quote data in top level namespace"]{
		loaddata . value scope;
		`quote mustin system"a";
	 };
 };
