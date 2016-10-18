#!/usr/bin/env bash

source bin/control.sh

startp discovery discovery1				--debug
startp housekeeping housekeeping1		--debug
startp btctrl btctrl1 					--debug
startp bttickerplant bttickerplant1		--debug
