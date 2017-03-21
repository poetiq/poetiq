\d .cal
endOf:()!() 									  / last date of (W)eek,(M)onth,(Q)uarter,(Y)year
endOf[`m]:{} 									  / last (m)inute of given time
endOf[`h]:{} 									  / last (h)our of given time
endOf[`W]:{8+7 xbar x-2} 						  / last date of (W)eek. Sunday by default.
endOf[`M]:{-1+"d"$1+"m"$x} 						  / last date of (M)onth
endOf[`Q]:{-1+"d"$3+3 xbar "m"$x}
endOf[`Y]:{}


trading.days:{} 								  / setting list of scheduled trading days. 