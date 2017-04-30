FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y \
    git \
    m4 \
    bison \
    flex \
    ccache \
    curl \
    wget \
    lzma \
    zlib1g-dev \
    liblzma-dev \
    ncurses-dev \
    python \
    unifont \
    libfreetype6-dev \
    automake \
    libdevmapper-dev \
    libzfslinux-dev \
    fcode-utils \
    build-essential \
    qt5-qmake qtbase5-dev qtdeclarative5-dev \
    libqt5webkit5-dev libsqlite3-dev

# Install coreboot toolchain
RUN \
  git clone http://review.coreboot.org/p/coreboot && \
  cd coreboot && \
  git submodule update --init --checkout && \
  make crossgcc-i386 CPUS=8

WORKDIR /coreboot

# Make ifdtool
RUN \
  cd util/ifdtool && \
  make

# Install UEFIExtract
RUN \
  git clone https://github.com/LongSoft/UEFITool.git && \
  cd UEFITool/UEFIExtract && \
  qmake --qt=qt5 && \
  make
