import serial

ser = serial.Serial('COM8', 4800, timeout=5)
i = 0
longitude_dd = 0.0;
while longitude_dd == 0.0 and i < 30:
    # increasing i; if i < 30 --> no fix achieved
    i += 1
    
    # Decode the bytes to a string using the correct encoding
    line = ser.readline().decode('ISO-8859-1') 
    splitline = line.split(',')
    
    # Getting GNGGA lines and checking if fix is active
    if (splitline[0] == '$GNGGA') and (splitline[6] != '0'): #if splitline[6] is 0, no GPS fix and invalid
        
        # Getting latitude/longitude DMM values
        latitude = float(splitline[2])
        longitude = float(splitline[4])
        
        # Getting latitude/longitude NSEW letters
        latitude_NS = splitline[3]
        longitude_EW = splitline[5]
        
        # DMM to DD conversion
        latitude_degrees = int(latitude) // 100;  # Get the degrees part
        latitude_minutes = (latitude % 100) / 60;  # Convert minutes to degrees
        latitude_dd = latitude_degrees + latitude_minutes;
        longitude_degrees = int(longitude) // 100;  # Get the degrees part
        longitude_minutes = (longitude % 100) / 60;  # Convert minutes to degrees
        longitude_dd = longitude_degrees + longitude_minutes;
        
        # Flipping signs for S and W coordinates
        if latitude_NS == 'S':
            latitude_dd = -latitude_dd;
        if longitude_EW == 'W':
            longitude_dd = -longitude_dd;
        
        # Output
        latitude_dd = round(latitude_dd, 6)
        longitude_dd = round(longitude_dd, 6)
        
        print("Latitude_dmm:", latitude)
        print("Longitude_dmm:", longitude)
        print("Latitude_dd:", latitude_dd)
        print("Longitude_dd:", longitude_dd)
        print("Latitude_NS:", latitude_NS)
        print("Longitude_EW:", longitude_EW)


    # if splitline[0] == '$GNVTG':

    # if splitline[0] == '$GPVTG':

# pos = {'latitude': 24, 'longitude': 44, 'velocity': 56.0}

# pos[]