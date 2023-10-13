import serial

ser = serial.Serial('COM8', 4800, timeout=5)
i = 0
while i < 200:
    line = ser.readline().decode('ISO-8859-1')  # Decode the bytes to a string using the correct encoding
    #print(line)
    i += 1
    splitline = line.split(',')

    if splitline[0] == '$GNGGA':
        k =3
        i += 1
        #print(line)
        #latitude = float(splitline[2])
        #longitude = float(splitline[4])
        #print(type(latitude))
        #print("Latitude:", latitude)
        #print("Longitude:", longitude)


    if splitline[0] == '$GNVTG':
        k=2
        i += 1
        print(line)
        

    if splitline[0] == '$GPVTG':
        k=3
        i += 1
        print(line)
