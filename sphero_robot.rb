require 'artoo/robot'

class SpheroRobot < Artoo::Robot

  connection :sphero, :adaptor => :sphero, :port => '127.0.0.1:4560'
  device :sphero, :driver => :sphero

  def initialize(params={})
    @lock = Mutex.new
    super params
  end

  def calibration_led(led_brightness)
    do_action do
      puts "Sphero brightness #{led_brightness}"
      sphero.back_led_output = led_brightness
    end
  end

  def calibrate(heading)
    do_action do
      puts "Sphero heading #{heading}"
      sphero.heading = heading
    end
  end

  def roll(speed, heading)
    do_action do
      puts "Sphero rolling #{speed}, #{heading}"
      sphero.roll(speed, heading)
    end
  end

  def color(rgb_ary)
    do_action do
      puts "Sphero color #{rgb_ary}"
      sphero.set_color(*rgb_ary)
    end
  end

  private

  def do_action
    if @lock.try_lock
      begin
        yield
      ensure
        @lock.unlock
      end
    end
  end
end
