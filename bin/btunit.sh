# Run each of these commands in a separate window during debugging

source bin/control.sh

startp hdb equitysim 					--debug
cd ${POETIQ}
startp gateway gateway1					--debug
cd ${POETIQ}
startp optimiser optimiser1				--debug
cd ${POETIQ}
startp oms oms1							--debug
cd ${POETIQ}
startp fillsim fillsim1					--debug
cd ${POETIQ}
startp portfolio portfolio1				--debug
cd ${POETIQ}
startp backtestfeed backtestfeed1		--debug
