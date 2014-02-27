#
# Skryf
#
# https://github.com/skryf/Skryf

FROM ubuntu
MAINTAINER Adam Stokes <adamjs@cpan.org>

# locales
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise-updates main universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise-proposed main universe multiverse" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install basic packages.
RUN apt-get install -y curl git perl perl-modules cpanminus cpanoutdated build-essential

RUN cpanm https://github.com/skryf/Skryf/archive/v1.0.5.tar.gz

