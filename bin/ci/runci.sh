#!/bin/bash
# source ${PROJECT_DIR}/bin/setenv.sh
# testq tests/test_test.q --junit | sed -n '/<testsuites>$/,$p'

source bin/setenv.sh
testq tests/test_test.q --junit | sed -n '/<testsuites>$/,$p'
