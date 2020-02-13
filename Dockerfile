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
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && xargs -a /tmp/apt-packages.txt apt-get install -y

# Reconfigure locales
RUN dpkg-reconfigure locales \
    && locale-gen C.UTF-8 \
    && /usr/sbin/update-locale LANG=C.UTF-8 \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && dpkg-reconfigure locales

# Clean-up
RUN apt-get autoremove -y \
    && apt-get clean -y

# Install python packages with pip
ADD /requirements/ /tmp/requirements/
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install -r /tmp/requirements/pre-requirements.txt \
    && python3 -m pip install https://github.com/ghislainv/forestatrisk/archive/master.zip

# End
