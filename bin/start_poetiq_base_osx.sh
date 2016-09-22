#!/bin/bash

BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $BIN/control.sh

startp -p discovery discovery1
startp -p housekeeping housekeeping1
startp -p hdb equitysim
startp -p gateway gateway1
