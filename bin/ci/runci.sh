#!/bin/bash

source bin/setenv.sh
testq tests/ --junit | sed -n '/<testsuites>$/,$p'

exit ${PIPESTATUS[0]}
