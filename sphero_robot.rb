require 'artoo/robot'

class SpheroRobot < Artoo::Robot

  attr_reader :command_q

  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero

  def initialize(params={})
    @command_q = params[:command_queue]
    super params
  end

  work do
    while true
      unless command_q.empty?
        command = command_q.next
        self.send(command.cmd, *command.args)
      end
    end
  end

  def calibration_led=(led_brightness)
    sphero.back_led_output = led_brightness
  end

  def calibrate(heading)
    sphero.heading = heading
    sphero.back_led_output = 0x00
  end

  def roll(speed, heading)
    sphero.roll(speed, heading)
  end

  def color=(*rgb_ary)
    sphero.set_color(*rgb_ary)
  end
end
