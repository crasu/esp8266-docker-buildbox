FROM ubuntu:14.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q git autoconf build-essential gperf bison flex texinfo libtool libncurses5-dev wget apt-utils gawk sudo unzip libexpat-dev vim python-serial python-pip

RUN useradd -d /home/esp8266 -m -s /bin/bash esp8266
RUN echo "esp8266 ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/esp8266
RUN chmod 0440 /etc/sudoers.d/esp8266
RUN mkdir /opt/Espressif/
RUN chown esp8266 /opt/Espressif/

USER esp8266

WORKDIR /opt/Espressif/
RUN git clone -b lx106 https://github.com/jcmvbkbc/crosstool-NG.git
WORKDIR /opt/Espressif/crosstool-NG
RUN ./bootstrap
RUN ./configure --prefix=`pwd`
RUN make -j`nproc`
RUN sudo make install
RUN ./ct-ng xtensa-lx106-elf
RUN ./ct-ng build

ENV PATH=/opt/Espressif/crosstool-NG/builds/xtensa-lx106-elf/bin:$PATH

WORKDIR /opt/Espressif/
RUN wget --content-disposition "http://bbs.espressif.com/download/file.php?id=1469"
RUN unzip ESP8266_NONOS_SDK_V1.5.4_16_05_20.zip
RUN mv ESP8266_NONOS_SDK ESP8266_SDK

WORKDIR /opt/Espressif/ESP8266_SDK
RUN wget -O lib/libc.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libc.a
RUN wget -O lib/libhal.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libhal.a
RUN wget -O include.tgz https://github.com/esp8266/esp8266-wiki/raw/master/include.tgz
RUN tar -xvzf include.tgz

RUN sudo pip install esptool
