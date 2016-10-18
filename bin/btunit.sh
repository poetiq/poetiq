# Run each of these commands in a separate window during debugging

source bin/control.sh

startp hdb equitysim 					--debug --args -new_console:nc:t:'hdb'
startp gateway gateway1				--debug --args -new_console:sVnc:t:'gateway'
startp optimiser optimiser1		--debug --args -new_console:nc:t:'optimiser'
startp oms oms1								--debug --args -e 1 -.clients.enabled 0 -.usage.enabled 0 -new_console:sHnc:t:'oms'
startp fillsim fillsim1				--debug --args -e 1 -.clients.enabled 0 -.usage.enabled 0 -new_console:s8TV:t:'fillsim'
startp portfolio portfolio1		--debug --args -e 1 -.clients.enabled 0 -.usage.enabled 0 -new_console:s9TV:t:'portfolio'
startp backtestfeed backtestfeed1	--debug --args -localtime -new_console:s4TV:t:'btfeed' -wait -trap -tbls mtm signal -bgn 2016.05.02 -end 2016.05.31 -syms AAPL PRU GOOG MSFT
