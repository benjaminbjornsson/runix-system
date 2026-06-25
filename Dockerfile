FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	bc \
	bison \
	bzip2 \
	ca-certificates \
	cpio \
	flex \
	gcc \
	gcc-x86-64-linux-gnu \
	libc6-dev-amd64-cross \
	libc6-dev \
	libelf-dev \
	libssl-dev \
	make \
	perl \
	xz-utils \
	&& rm -rf /var/lib/apt/lists/*
