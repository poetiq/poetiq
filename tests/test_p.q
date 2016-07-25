\l p.q

.tst.desc["Portfolio Tracker"]{
	before{
		/ TODO: Wrap in reset[] function
		`positions mock delete from positions;
		`pnl mock delete from pnl;
	 	`cash mock 1e5;

		`txns mock ([] dt:1 2 3 4; sym:4#`AAPL; sz:100 200 -200 -50; px:50 52 53 53.5);
		`prices mock ([] sym:4#`AAPL; dt:1 2 3 4; cl:50.5 52 53 54);
	};
	should["fill a transaction"]{
		mustnotthrow[();(`upd;`fill;first txns)];
	};
	should["calculate equity after fills"]{
		upd[`fill] each txns;
		upd[`mtm] prices;
		/ equity musteq 100575f;
		/ issue with testing the view above
		equity musteq cash + exec sum pnl from pnl;
	};
	should["calculate position after fills"]{
		upd[`fill] each txns;
		upd[`mtm] prices;
		positions mustmatch 1!enlist`sym`sz`cost`dt!(`AAPL;50i;54f;4i);
	};
	should["calculate P&L after fills"]{
		upd[`fill] each txns;
		upd[`mtm] prices;
		pnl mustmatch ([] sym:4#`AAPL; dt:2 3 4 4i; pnl:200 300 50 25f);
	};
	should["calculate position and P&L in batch"]{
		upd[`fill] each txns;
		upd[`mtm] prices;
		batch:([] dt:1+til 4; sym:4#`AAPL; sz:100 200 -200 -50; px:50 52 53 53.5; cl:50.5 52 53 54; pnl:50 150 300 75f);
		batch mustmatch pnlCalc[txns;prices];
	};
 };

\
run with:
testq tests/test_p.q --noquit
