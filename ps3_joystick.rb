require_relative 'controller_joystick'

class PS3Joystick < ControllerJoystick
  connection :joystick, :adaptor => :joystick
  device :controller, :driver => :ps3, :connection => :joystick, :interval => 0.1, :usb_driver => :osx

  work do
    on controller, :button_r1 => :button_rb_action
    on controller, :button_up_r1 => :button_up_rb_action
    on controller, :button_j1 => :button_j1_action
    on controller, :joystick_0 => :joystick0_action
    on controller, :joystick_1 => :joystick1_action
  end

end
