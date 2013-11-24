class Command
  include Comparable

  attr_reader :priority, :type, :time, :cmd, :args, :removable

  def initialize(params={})
    params = defaults.merge(params)

    @priority ||= params[:priority]
    @type ||= params[:type]

    @cmd = params[:cmd]
    @args = params[:args]
    @time = Time.now

    @removable ||= true
  end

  def defaults
    { :priority => 0, :type => :default }
  end

  def <=>(rhs_cmd)
    # Oldest first
    rhs_cmd.time <=> time
  end

  class ButtonCommand < Command
    def initialize(params={})
      @priority = params[:priority] || 5
      @type = :button
      @removable = false
      super params
    end
  end

  class JoystickCommand < Command
    def initialize(params={})
      @priority = params[:priority] || 1
      @type = :joystick
      super params
    end
  end

end
