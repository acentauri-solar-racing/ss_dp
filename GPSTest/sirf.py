'''
Data from http://www.usglobalsat.com/store/downloads/NMEA_commands.pdf

TODO: try usglobalsat.com/downloads/SiRF_Binary_Protocol.pdf
'''

import serial
import pynmea2

class RF103(pynmea2.NMEASentence):
    fields = (
        ('Sentence type', 'sentence'),
            # 00=GGA
            # 01=GLL
            # 02=GSA
            # 03=GSV
            # 04=RMC
            # 05=VTG
        ('Command', 'command'),
            # 0=Set
            # 1=Query
        ('Rate', 'rate'),
        ('Checksum', 'checksum'),
            # 0=No, 1=Yes
    )


class RF100(pynmea2.NMEASentence):
    fields = (
        ('Protocol', 'protocol'),
        # 0 = SiRF Binary
        # 1 = NMEA
        ('Baud Rate', 'baud'),
        # 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200
        ('Data bits', 'databits'),
        # 8 (, 7 in NMEA)
        ('Stop bits', 'stopbits'),
        # 0, 1
        ('Parity', 'parity'),
        # 0, 1=Odd, 2=Even
    )


class SirfSerial(serial.Serial):
    def _set_msg(msg):
        def set_msg(self, value):
            sentence = RF103(
                'PS', 'RF103',
                '%02d' % msg, '0', '%d' % value, '1')
            data = sentence.render(checksum=True, dollar=True, newline=True)
            self.write(data)
        return set_msg

    @staticmethod
    def autoopen(**kwargs):
        for b in (1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200):
            pass

    set_gga = _set_msg(0)
    set_gll = _set_msg(1)
    set_gsa = _set_msg(2)
    set_gsv = _set_msg(3)
    set_rmc = _set_msg(4)
    set_vtg = _set_msg(5)
    set_mss = _set_msg(6)
    set_zda = _set_msg(8)

    def set_protocol(self, proto=1, baud=4800, data=8, stop=1, parity=0):
        '''
        '''
        sentence = RF100(
            'PS', 'RF100', '%d' % proto,
            '%d' % baud, '%d' % data, '%d' % stop, '%d' % parity)
        data = sentence.render(checksum=True, dollar=True, newline=True)
        print data
        self.write(data)

        # if baud != self.baudrate:
        #     self.close()
        #     self.baudrate = baud
        #     self.open()