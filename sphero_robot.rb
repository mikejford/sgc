require 'artoo/robot'

class SpheroRobot < Artoo::Robot

  connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
  device :sphero, :driver => :sphero, :interval => 0.1

  def calibration_led led_brightness
    sphero.back_led_output = led_brightness
  end

  def calibrate heading
    sphero.heading = heading
  end

  def roll speed, heading
    sphero.roll = speed, heading
  end

end

