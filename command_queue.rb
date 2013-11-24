require 'thread'
require 'algorithms'

class CommandQueue

  attr_reader :cmd_q

  def initialize
    @lock = Mutex.new
    @cmd_q = Containers::PriorityQueue.new
  end

  def add(command)
    @lock.synchronize do
      # Expire old commands
      if command.removable
        while cmd_q.has_priority?(command.priority)
          cmd_q.delete(command.priority)
        end
      end
      # Add the command to the queue
      cmd_q.push(command, command.priority)
    end
  end

  def next
    @lock.synchronize do
      # Get the next command from the queue
      cmd_q.pop
    end
  end

  def empty?
    @lock.synchronize do
      cmd_q.empty?
    end
  end
end
