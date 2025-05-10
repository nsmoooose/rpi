#!/usr/bin/env python3
import luma
from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import sh1106
import datetime
import json
import time


if __name__ == "__main__":
    serial = i2c(port=1, address=0x3C)
    device = sh1106(serial, rotate=0)

    last_ts = ""
    last_temp = -1.0
    last_humidity = -1.0

    with canvas(device) as draw:
        draw.rectangle(device.bounding_box, outline="white", fill="black")
        draw.text((5, 5), "Waiting for data", fill="white")

    while True:
        with canvas(device) as draw:
            draw.rectangle(device.bounding_box, outline="white", fill="black")

            draw.text((5, 5), "%s" % last_ts, fill="white")
            draw.text((5, 15), "Temperature: %.1f°" % last_temp, fill="white")
            draw.text((5, 25), "Humidity: %.1f%%" % last_humidity, fill="white")

        time.sleep(1)

