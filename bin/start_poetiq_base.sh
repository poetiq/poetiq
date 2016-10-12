#!/bin/bash

BIN="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $BIN/control.sh

startp discovery discovery1
startp housekeeping housekeeping1
startp hdb equitysim
startp gateway gateway1
