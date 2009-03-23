module Sweep
  class Task
    attr_accessor :name, :args, :dependencies, :behavior, :owner, :desc
  
    alias :prerequisites :dependencies
  
    def inspect
      "#<Task:'#{full_name}'>"
    end
    
    # Show the task's name plus it's namespaces' names
    def full_name
      "#{owner.full_name}#{name}"
    end
  
    # Do we need to run this task? (For normal tasks, always yes.  Could be overridden for special task types as
    # I did with FileTask and DirectoryTask)
    def run_task?
      true
    end
  
    def initialize(name)
      @name = name
      @args = []
      @dependencies = []
    end
  
    # Invoke the task unless we don't need to according to run_task?
    def invoke!
      self.behavior.call(self, *args) unless !run_task?
    end
  end
end