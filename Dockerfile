FROM ubuntu:14.04
MAINTAINER sharaku

# ############################################################################
# installation of develop

# ----------------------------------------------------------------------
# update
RUN apt-get update

# ----------------------------------------------------------------------
# install sshd
RUN \
  apt-get install -y openssh-server && \
  mkdir /var/run/sshd && \
  sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# ----------------------------------------------------------------------
# install base tools.
RUN apt-get install -y wget git vim bzip2 nkf unzip bc build-essential

# ----------------------------------------------------------------------
# add-apt-repositoryインストール
RUN \
  apt-get update && \
  apt-get install -y software-properties-common

# ----------------------------------------------------------------------
# ARM Toolchainのinstall
RUN \
  DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:terry.guo/gcc-arm-embedded && \
  apt-get update
RUN \
  apt-get install -y gcc-arm-none-eabi=4.9.3.2015q1-0trusty13 u-boot-tools libboost1.55-all-dev

# ----------------------------------------------------------------------
# install cppcheck
RUN apt-get install -y cppcheck

# ----------------------------------------------------------------------
# jenkins client (java sdk)
RUN apt-get install -y default-jdk

# ----------------------------------------------------------------------
# qemu installed
RUN apt-get install -y qemu

# ----------------------------------------------------------------------
# install ev3rt package.
#RUN \
#  mkdir /var/lib/ev3rt && \
#  wget --no-check-certificate http://www.toppers.jp/download.cgi/ev3rt-beta4-release.zip -P /tmp/ \
#  unzip /tmp/ev3rt-beta4-release.zip -d /var/lib/ev3rt/
#  cd /var/lib/ev3rt/ev3rt-beta4-release/
#  tar Jxvf ev3rt-beta4-utf8-lf.tar.xz
#  rm ev3rt-beta4-utf8-lf.tar.xz
#  cd hrp2/cfg
#  make

# ############################################################################
# add start sh
ADD ./start.sh /opt/start.sh
RUN \
  chmod 555 /opt/start.sh

# ############################################################################
# settings

USER root
ENV HOME /root
ENV LOGIN_USER root:root

EXPOSE 22

CMD    ["/opt/start.sh"]
