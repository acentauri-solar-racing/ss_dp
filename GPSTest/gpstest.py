import time
import serial
import pynmea2

import sirf

port = sirf.SirfSerial('COM8', 4800, timeout=0.01)

while 1:
    data = port.readline()
    if not data:
        continue
    try:
        pynmea2.parse(data)
        break
    except ValueError:
        k = 2 #print data

# now connected
# port.set_protocol(baud=9600)

port.set_gga(1)
port.set_gll(0)
port.set_gsa(1)
port.set_gsv(5)
port.set_rmc(0)
port.set_vtg(1)
port.set_zda(0)


while 1:
    data = port.readline()
    if not data:
        time.sleep(0.1)
        continue
    msg = pynmea2.parse(data)
    print ('%.3f %s' % (time.time(), msg))