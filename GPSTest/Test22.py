from GPSPlayground import BU343S4Driver

gps = BU343S4Driver('COM8')

gps.update_position()

gps.get_latitude()