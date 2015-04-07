# HowGood Python Container
# howgood/python

FROM howgood/base

# Python env
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV C_FORCE_ROOT 1

# Pip env
ENV XDG_CACHE_HOME /tmp
RUN mkdir -p $XDG_CACHE_HOME

# Install pip
RUN curl -SL 'https://bootstrap.pypa.io/get-pip.py' | python

# Install PyOpenSSL bindings http://goo.gl/hnEhGx
RUN pip install --compile --upgrade \
      pyopenssl \
      ndg-httpsclient \
      pyasn1 \
    && rm -Rf /tmp/*

# Add the bin scripts
COPY ./bin /usr/local/bin/
