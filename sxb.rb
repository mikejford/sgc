require_relative 'xbox_joystick'
require_relative 'sphero_robot'
require_relative 'command_queue'

cmd_q = CommandQueue.new()

xbjs = XboxJoystick.new({ :command_queue => cmd_q })
sphero_bot = SpheroRobot.new({ :command_queue => cmd_q })

Artoo::Robot.work!([xbjs, sphero_bot])
