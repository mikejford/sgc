require 'artoo/robot'

class XboxJoystick < Artoo::Robot

  MAX_AXIS_RADIUS = 32768

  attr_reader :sphero_bot

  connection :joystick, :adaptor => :joystick
  device :controller, :driver => :xbox360, :connection => :joystick, :interval => 0.1, :usb_driver => :tattiebogle

  def initialize params={}
    @sphero_bot = params[:sphero]
    super params
  end

  work do
    on controller, :button_rb => proc { |*value|
      # turn on sphero back led
      sphero_bot.calibration_led(0xff)
    }
    on controller, :button_up_rb => proc { |*value|
      # turn off sphero back led
      sphero_bot.calibration_led(0x00)
    }
    #on controller, :joystick_0 => :joystick_action
  end

  private 

  def joystick_action *value
    x = value[1][:x]
    y = value[1][:y]

    calibrating = controller.button_values[controller.button_map.key(:rb)]

    r = speed_value x, y
    theta = heading_value x, y

    if calibrating == 1
      sphero_bot.calibrate(theta)
    else
      if r > 0
        sphero_bot.roll(r, theta)
      end
    end
  end

  def speed_value x, y
    num = Math.sqrt(x**2 + y**2)

    if num > MAX_AXIS_RADIUS
      num = MAX_AXIS_RADIUS
    elsif num < MAX_AXIS_RADIUS * 0.2
      num = 0
    end

    (num * 255 / MAX_AXIS_RADIUS).to_i
  end

  def heading_value x, y
    (Math.atan2(x, y) * (180.0 / Math::PI) - 180.0).abs.to_i
  end

end

