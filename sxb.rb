require_relative 'ps3_joystick'
require_relative 'xbox360_joystick'
require_relative 'sphero_robot'
require_relative 'command_queue'

cmd_q = CommandQueue.new()

cjs = PS3Joystick.new({ :command_queue => cmd_q })
#cjs = XBox360Joystick.new({ :command_queue => cmd_q })
sphero_bot = SpheroRobot.new({ :connections => { :sphero => { :port => '127.0.0.1:4560' } },
                               :command_queue => cmd_q })

Artoo::Robot.work!([cjs, sphero_bot])
