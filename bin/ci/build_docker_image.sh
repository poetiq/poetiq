#!/bin/bash

POETIQ_PATH=$1
KDB_URL=$2

VERSION_TAG=$(git --git-dir $POETIQ_PATH/.git log $CIRCLE_BRANCH -n 1 --pretty=format:%H -- Dockerfile circle.yml bin/ci/)
IMAGE_FULL_NAME="poetiq/poetiq:${VERSION_TAG}"

echo -e "Commit SHA1:\t${CIRCLE_SHA1}"
echo -e "Image SHA1:\t${VERSION_TAG}"
echo -e "Image name:\t${IMAGE_FULL_NAME}\n"

CACHE_DIR=$(readlink -f ~/docker)
IMAGE_ARCHIVE="${CACHE_DIR}/poetiq.tar"

if [ -e "${IMAGE_ARCHIVE}" ]; then
	echo -e "Loading archive: ${IMAGE_ARCHIVE}\n"
	docker load -i "${IMAGE_ARCHIVE}"
fi

if [ -z $(docker images -q $IMAGE_FULL_NAME) ]; then
	echo -e "No matching image found. Building new image: ${IMAGE_FULL_NAME}\n"
	docker build --build-arg KDB_URL=${KDB_URL} -t "${IMAGE_FULL_NAME}" $POETIQ_PATH/
	echo -e "Saving image to cache: ${IMAGE_ARCHIVE}\n"
	mkdir -p ${CACHE_DIR}
	docker save "${IMAGE_FULL_NAME}" > "${IMAGE_ARCHIVE}"
fi
