#!/usr/bin/env bash

source bin/control.sh

startp discovery discovery1					--debug --args -new_console:nc:t:'discovery'
startp housekeeping housekeeping1		--debug --args -new_console:sVnc:t:'housekeeping'
startp btctrl btctrl1 							--debug --args -e 1 -.clients.enabled 0 -.usage.enabled 0 -new_console:s2THnc:t:'btctrl'
startp bttickerplant bttickerplant1	--debug --args -e 1 -c 25 200 -new_console:nc:t:'tickerplant'
