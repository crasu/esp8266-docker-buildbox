ESP8266 Docker Buildbox
=======================

Usage
=====

Build
> docker build -t esp8266-docker-crasu 

Run
> docker run -ti -v $(pwd):/docker-build esp8266-docker-crasu /bin/bash

Inside container sample checkout&compile
> https://github.com/espressif/esp8266-nonos-sample-code
> cd source-code-examples/basic_example
> make

Outside container flash
> esptool.py  --port /dev/ttyUSB0 write_flash --flash_mode dio 0x00000 firmware/0x00000.bin 0x40000 firmware/0x40000.bin
