require_relative 'xbox_joystick'
require_relative 'sphero_robot'

sphero_bot = SpheroRobot.new()
xbjs = XboxJoystick.new({ :sphero => sphero_bot })
XboxJoystick.work!([xbjs])
