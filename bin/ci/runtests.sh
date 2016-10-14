#!/bin/bash

POETIQ_PATH=$1
VERSION_TAG=$(git --git-dir $POETIQ_PATH/.git log $CIRCLE_BRANCH -n 1 --pretty=format:%H -- Dockerfile circle.yml bin/ci/)
IMAGE_FULL_NAME="poetiq/poetiq:${VERSION_TAG}"

mkdir -p ${CIRCLE_TEST_REPORTS}/junit

TEST_RESULT=$(docker run -v $POETIQ_PATH:/poetiq ${IMAGE_FULL_NAME} runci)
EXIT_CODE=$?

echo $TEST_RESULT > ${CIRCLE_TEST_REPORTS}/junit/test_results.xml

exit $EXIT_CODE
