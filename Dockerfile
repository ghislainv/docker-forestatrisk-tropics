#!/usr/bin/env bash
# docker-forestatrisk-tropics

# Base image
FROM debian:buster
MAINTAINER Ghislain Vieilledent <ghislain.vieilledent@cirad.fr>

# Terminal
ENV TERM=xterm

# Install debian packages with apt-get
ADD apt-packages.txt /tmp/apt-packages.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    xargs -a /tmp/apt-packages.txt apt-get install -y

# Set LOCALE to UTF8
RUN apt-get install -y locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Clean-up
RUN apt-get autoremove -y && \
    apt-get clean -y

# Install RClone
RUN URL=http://downloads.rclone.org/rclone-current-linux-amd64.zip && \
  cd /tmp && \
  wget -q $URL && \
  unzip /tmp/rclone-current-linux-amd64.zip && \
  mv /tmp/rclone-*-linux-amd64/rclone /usr/bin && \
  rm -rf /tmp/* && \
  chown root:root /usr/bin/rclone && \
  chmod 755 /usr/bin/rclone

# Create virtual env and activate it
ENV VIRTUAL_ENV=/opt/venv-far
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install python packages with pip
ADD /requirements/ /tmp/requirements/
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r /tmp/requirements/pre-requirements.txt && \
    python3 -m pip install --global-option=build_ext --global-option="-I/usr/include/gdal" gdal==$(gdal-config --version) && \
    python3 -m pip install https://github.com/ghislainv/forestatrisk/archive/master.zip && \
    python3 -m pip install -r /tmp/requirements/additional-reqs.txt

# Specific MBB cluster config
RUN mkdir -p /share/apps/bin && \
  mkdir /share/apps/lib && \
  mkdir /share/apps/gridengine && \
  mkdir /share/bio && \
  mkdir -p /opt/gridengine && \
  mkdir -p /export/scrach && \
  mkdir -p /usr/lib64 && \
  /usr/sbin/groupadd --system --gid 400 sge && \
  /usr/sbin/useradd --system --uid 400 --gid 400 -c GridEngine --shell /bin/true --home /opt/gridengine sge && \
  ln -s /bin/bash /bin/mbb_bash && \
  ln -s /bin/bash /bin/isem_bash

# End
