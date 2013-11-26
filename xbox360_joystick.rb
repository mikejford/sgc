require_relative 'controller_joystick'

class XBox360Joystick < ControllerJoystick
  connection :joystick, :adaptor => :joystick
  device :controller, :driver => :xbox360, :connection => :joystick, :interval => 0.1, :usb_driver => :osx

  work do
    on controller, :button_rb => :button_rb_action
    on controller, :button_up_rb => :button_up_rb_action
    on controller, :button_j1 => :button_j1_action
    on controller, :joystick_0 => :joystick0_action
    on controller, :joystick_1 => :joystick1_action
  end

end
