require_relative 'controller_joystick'
require_relative 'sphero_robot'
require_relative 'command_queue'

cmd_q = CommandQueue.new()

cjs = ControllerJoystick::XBox360.new({ :command_queue => cmd_q })

sphero_bot = SpheroRobot.new({ :connections => { :sphero => { :port => '127.0.0.1:4560' } },
                               :command_queue => cmd_q })

Artoo::Robot.work!([cjs, sphero_bot])
