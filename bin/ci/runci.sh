#!/bin/bash

source bin/setenv.sh
testq tests/test_test.q --junit | sed -n '/<testsuites>$/,$p'

exit ${PIPESTATUS[0]}
