# HowGood Python Container
# howgood/python

FROM howgood/base

################################################
# Copied from python:3.6 git.io/vDARg #
################################################

ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       tcl \
       tk \
       wget \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.6.0

RUN set -ex \
  && buildDeps=' \
    tcl-dev \
    tk-dev \
  ' \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
  \
  && wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
  && wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
  && gpg --batch --verify python.tar.xz.asc python.tar.xz \
  && rm -r "$GNUPGHOME" python.tar.xz.asc \
  && mkdir -p /usr/src/python \
  && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
  && rm python.tar.xz \
  \
  && cd /usr/src/python \
  && ./configure \
    --enable-loadable-sqlite-extensions \
    --enable-shared \
  && make -j$(nproc) \
  && make install \
  && ldconfig \
	\
	&& if [ ! -e /usr/local/bin/pip3 ]; then : \
		&& curl -fSL -o /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
		&& python3 /tmp/get-pip.py \
		&& rm /tmp/get-pip.py \
	; fi \
	&& pip3 install --no-cache-dir --upgrade --force-reinstall pip \
	&& find /usr/local -depth \
		\( \
			\( -type d -a -name test -o -name tests \) \
			-o \
			\( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/python ~/.cache /tmp/*


############
# End copy #
############

# Python env
ENV C_FORCE_ROOT=1 \
    XDG_CACHE_HOME=/tmp
