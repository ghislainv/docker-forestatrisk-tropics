#!/usr/bin/env bash
# docker-forestatrisk-tropics

# Base image
FROM debian:buster
MAINTAINER Ghislain Vieilledent <ghislain.vieilledent@cirad.fr>

# Terminal
ENV TERM=xterm
ENV LC_ALL C.UTF-8

# Install debian packages with apt-get
ADD apt-packages.txt /tmp/apt-packages.txt
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    xargs -a /tmp/apt-packages.txt apt-get install -y

# Reconfigure locales
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    dpkg-reconfigure locales

# Clean-up
RUN apt-get autoremove -y && \
    apt-get clean -y

# Install python packages with pip
ADD /requirements/ /tmp/requirements/
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r /tmp/requirements/pre-requirements.txt && \
    python3 -m pip install https://github.com/ghislainv/forestatrisk/archive/master.zip && \
    python3 -m pip install -r /tmp/requirements/additional-reqs.txt

# Install RClone
RUN URL=http://downloads.rclone.org/rclone-current-linux-amd64.zip && \
  cd /tmp && \
  wget -q $URL && \
  unzip /tmp/rclone-current-linux-amd64.zip && \
  mv /tmp/rclone-*-linux-amd64/rclone /usr/bin && \
  rm -rf /tmp/* && \
  chown root:root /usr/bin/rclone && \
  chmod 755 /usr/bin/rclone

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
