require 'artoo/robot'
require_relative 'command'

class XboxJoystick < Artoo::Robot
  MAX_AXIS_RADIUS = 32768

  attr_reader :command_q, :last_heading, :last_speed, :j1_active

  connection :joystick, :adaptor => :joystick
  device :controller, :driver => :xbox360, :connection => :joystick, :interval => 0.1, :usb_driver => :tattiebogle

  def initialize(params={})
    @command_q = params[:command_queue]
    @last_heading = nil
    @last_speed = 0
    @j1_active = false
    super params
  end

  work do
    on controller, :button_rb => :button_rb_action
    on controller, :button_up_rb => :button_up_rb_action
    on controller, :button_j1 => :button_j1_action
    on controller, :joystick_0 => :joystick0_action
    on controller, :joystick_1 => :joystick1_action
  end

  private 

  def button_rb_action(*value)
    # turn on sphero back led
    command_q.add(Command::ButtonCommand.new({
      :cmd => :calibration_led= ,
      :args => 0xff
    }))
  end

  def button_up_rb_action(*value)
    # turn off sphero back led
    unless last_heading.nil?
      command_q.add(Command::ButtonCommand.new({
        :cmd => :calibrate ,
        :args => last_heading
      }))
      @last_heading = nil
    end
  end

  def button_j1_action(*value)
    @j1_active = !j1_active
  end

  def joystick0_action(*value)
    x = value[1][:x]
    y = value[1][:y]

    speed = speed_value x, y
    heading = heading_value x, y

    add_cmd = true
    if last_speed == 0 && speed == last_speed
      add_cmd = false
    end

    if controller.currently_pressed?(:rb) == 1
      # capture last heading value for calibration
      @last_heading = heading

      # set roll speed to 0 while calibrating
      speed = 0

      # add all calibration commands
      add_cmd = true
    end

    command_q.add(Command::JoystickCommand.new({
      :cmd => :roll ,
      :args => [ speed, heading ]
    })) if add_cmd

    @last_speed = speed
  end

  def joystick1_action(*value)
    if j1_active
      x = value[1][:x]
      y = value[1][:y]

      hue = hue_value x, y
      saturation = saturation_value x, y

      command_q.add(Command::JoystickCommand.new({
        :cmd => :color= ,
        :args => hsv_to_rgb( hue, saturation, 1 ) ,
        :priority => 3
      }))
    end
  end

  def speed_value(x, y)
    s = radial_value x, y

    if s > MAX_AXIS_RADIUS
      # set a limit on upper speed to 255
      s = MAX_AXIS_RADIUS
    elsif s < MAX_AXIS_RADIUS * 0.2
      # set a limit on lower speed to roughly 50
      s = 0
    end

    (s * 255 / MAX_AXIS_RADIUS).to_i
  end

  def heading_value(x, y)
    h = angular_value x, y
    (h - 180.0).abs.to_i
  end

  def hue_value(x, y)
    h = angular_value x, y
    (h + 180.0).to_i
  end

  def saturation_value(x, y)
    s = radial_value x, y

    if s > MAX_AXIS_RADIUS
      s = MAX_AXIS_RADIUS
    elsif s < MAX_AXIS_RADIUS * 0.1
      s = 0
    end

    s / MAX_AXIS_RADIUS
  end

  def radial_value(x, y)
    Math.sqrt(x**2 + y**2)
  end

  def angular_value(x, y)
    Math.atan2(x, y) * (180.0 / Math::PI)
  end

  def hsv_to_rgb(h, s, v)
    h_i = (h / 60).to_i
    f = h / 60 - h_i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    r, g, b = v, t, p if h_i == 0
    r, g, b = q, v, p if h_i == 1
    r, g, b = p, v, t if h_i == 2
    r, g, b = p, q, v if h_i == 3
    r, g, b = t, p, v if h_i == 4
    r, g, b = v, p, q if h_i == 5
    [(r * 255).to_i, (g * 255).to_i, (b * 255).to_i]
  end

end
